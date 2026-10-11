import os

from llama_index.core import Document, StorageContext, VectorStoreIndex
from llama_index.vector_stores.chroma import ChromaVectorStore

def index_data_to_collection(
    db, collection_name, data_path: str, file_extensions: str | tuple[str, ...]
):
    chroma_collection = db.get_or_create_collection(collection_name)
    vector_store = ChromaVectorStore(chroma_collection=chroma_collection)
    storage_context = StorageContext.from_defaults(vector_store=vector_store)

    documents = []
    if os.path.exists(data_path):
        for root, dirs, files in os.walk(data_path):
            for filename in files:
                if filename.endswith(file_extensions):
                    filepath = os.path.join(root, filename)
                    with open(filepath, "r", encoding="utf-8", errors="ignore") as f:
                        content = f.read()
                        documents.append(
                            Document(text=content, metadata={"source": filename})
                        )

    VectorStoreIndex.from_documents(documents, storage_context=storage_context)
    print(
        f"Collection '{collection_name}' successfully updated "
        f"({len(documents)} files)."
    )
