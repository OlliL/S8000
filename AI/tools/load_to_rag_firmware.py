from lib.rag_indexer import index_data_to_collection
from lib.rag_config import db
import os.path

index_data_to_collection(db, "zilog_firmware", os.path.expanduser("~/git/S8000/firmware/CPU/1.2/"), ".s")
