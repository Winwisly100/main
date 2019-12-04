package document

import (
	"context"

	v1 "github.com/winwisely99/main/server/packages/document/api/v1"
)

// Repository interface
type Repository interface {
	Close()
	New(ctx context.Context, userID string, documents *v1.Document) (*v1.Document, error)
	Merge(ctx context.Context, userID string, documents *v1.Document) (*v1.Document, error)
	List(ctx context.Context, userID string) ([]*v1.Document, error)
	Sync(ctx context.Context, userID string, documents *v1.Document) (string, error)
}
