import chromadb
import os.path
from llama_index.core import Settings
from llama_index.embeddings.huggingface import HuggingFaceEmbedding
from llama_index.llms.ollama import Ollama


Settings.llm = Ollama(
    model="llama3",
    request_timeout=240.0,
    temperature=0.0,
    additional_kwargs={"num_ctx": 8192},
)

# noinspection PyArgumentList
Settings.embed_model = HuggingFaceEmbedding(
    model_name="BAAI/bge-small-en-v1.5"
)

db = chromadb.PersistentClient(path=os.path.expanduser("~/git/S8000/AI/s8000_rag_chroma_db"))
