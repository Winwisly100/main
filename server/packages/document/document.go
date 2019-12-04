package document

import (
	"context"
	"fmt"
	v1 "github.com/winwisely99/main/server/packages/document/api/v1"
	"log"
	"sync"
	"time"
)

// documentServiceServer is implementation of DocumentServiceServer proto interface
type documentServiceServer struct {
	repository Repository
}

// NewDocumentServiceServer creates Document service object
func NewDocumentServiceServer() v1.DocumentServiceServer {
	return &documentServiceServer{}
}

// CheckIfDocumentsSync Check if local documents are sync with server
func (d *documentServiceServer) CheckIfDocumentsSync(list *v1.RequestCheckSync, stream v1.DocumentService_CheckIfDocumentsSyncServer) error {

	responseChecks := make(chan *v1.ResponseCheckSync, len(list.Checks))

	wg := sync.WaitGroup{}

	// Get all user documents
	docs, err := d.repository.List(context.Background(), list.Uid)

	if err != nil {
		return err
	}

	// context timeout
	ctx, f := context.WithTimeout(context.Background(), time.Second*10)
	defer f()

	wg.Add(1)
	// Start a goroutine function to stream ResponseCheck to client
	go func() {
		for {
			select {

			case <-ctx.Done():
				wg.Done()
				return

			case r := <-responseChecks:

				if err := stream.Send(r); err != nil {
					log.Printf("Error to send %v\n", err)
					close(responseChecks)
					wg.Done()
					return
				}
			}
		}
	}()

	// move all user document to a map
	serverDocuments := make(map[string]*v1.Document)
	for _, d := range docs {
		serverDocuments[d.LocalId] = d
	}

	// Check local document with server
	for _, checkDoc := range list.Checks {
		srvDoc, ok := serverDocuments[checkDoc.LocalId]
		r := &v1.ResponseCheckSync{}

		if !ok {
			// Check if local document not exists on server
			r.LocalId = checkDoc.LocalId
			r.Conflict = v1.ConflictStatus_NEW
		} else {
			if srvDoc.GetLastUpdate().GetSeconds() != checkDoc.GetLastUpdate().GetSeconds() {
				// Check if local document lastUpdated not equal to server document
				r.LocalId = checkDoc.LocalId
				r.Conflict = v1.ConflictStatus_OUTDATED
			} else {
				// when local document is sync with server
				r.LocalId = checkDoc.GetId()
				r.Conflict = v1.ConflictStatus_SYNC
			}
		}
		responseChecks <- r
	}

	wg.Wait()
	return nil
}

// SyncDocuments Sync local documents with server
func (d *documentServiceServer) SyncDocuments(stream v1.DocumentService_SyncDocumentsServer) error {

	docsReceved := 0

	responseSync := make(chan *v1.ResponseCheckSync, 64)
	reciveSync := make(chan *v1.Document, 64)

	ctx, f := context.WithTimeout(context.Background(), time.Second*20)
	defer f()

	wg := sync.WaitGroup{}

	// Start a goroutine function to stream ResponseCheck to client
	wg.Add(1)

	go func() {
		defer wg.Done()

		for {
			select {

			case <-ctx.Done():
				log.Println("Timeout request")
				return
			// case receive a request document to sync
			case sDoc := <-reciveSync:

				switch sDoc.GetType() {

				case v1.SyncType_NOTHING:
					break

				// sync by creating new document
				case v1.SyncType_CREATE:
					document, _ := d.repository.New(ctx, sDoc.GetUid(), sDoc)
					responseSync <- &v1.ResponseCheckSync{
						Id:       document.GetId(),
						LocalId:  document.GetLocalId(),
						Conflict: document.GetConflict(),
					}
					break

				// sync by merging document
				case v1.SyncType_MERGE:
					fmt.Println("Merge")
					document, _ := d.repository.Merge(ctx, sDoc.GetUid(), sDoc)
					responseSync <- &v1.ResponseCheckSync{
						Id:       document.GetId(),
						LocalId:  document.GetLocalId(),
						Conflict: document.GetConflict(),
					}
					break
				}

			case r := <-responseSync:
				if err := stream.Send(r); err != nil {
					return
				}
				break
			}
		}
	}()

	wg.Add(1)

	go func() {
		defer wg.Done()

		for {
			select {

			case <-ctx.Done():
				log.Println("Timeout request")
				return
			default:

				syncDocument, err := stream.Recv()

				if err != nil {
					log.Println(err)
					return
				}

				if syncDocument != nil {
					docsReceved++
					reciveSync <- syncDocument
				}
			}
		}
	}()

	wg.Wait()
	return nil
}
