from llama_index.core import Settings, VectorStoreIndex
from llama_index.core.chat_engine.types import ChatMode
from llama_index.vector_stores.chroma import ChromaVectorStore
from lib.rag_config import db

print("Initializing Conversational Deep RAG Engine for Firmware Analysis...")

chroma_collection = db.get_collection("zilog_firmware")

# 4. Set up vector store and index
vector_store = ChromaVectorStore(chroma_collection=chroma_collection)
index = VectorStoreIndex.from_vector_store(
    vector_store, embed_model=Settings.embed_model
)

# 5. Create a Conversational Chat Engine with RAG backing
# - chat_mode="condense_plus_context": Combines chat history with new queries for precise retrieval
# - similarity_top_k=6: Fetches relevant code snippets per turn
system_prompt = (
    "You are a highly precise senior embedded software engineer and reverse engineer, specialized in Zilog architectures.\n"
    "Your task is to analyze assembly source code snippets in an ongoing interactive dialogue.\n"
    "Maintain context across user questions, perform cross-reference checks between routines, explain logical causality "
    "and hardware interactions (handshakes, ports, flags), and never invent non-existent registers."
)

chat_engine = index.as_chat_engine(
    chat_mode=ChatMode.CONDENSE_PLUS_CONTEXT,
    similarity_top_k=6,
    system_prompt=system_prompt,
    verbose=False
)

# 6. Interactive Chat Loop
print("=== Z8000 Interactive Firmware Chat Engine (Multi-Turn Refinement) ===")
print("Type your questions or follow-ups. Type 'exit' to quit.\n")

while True:
    try:
        user_input = input("You / Follow-up: ").strip()

        if user_input.lower() in ["exit", "quit", "q"]:
            print("Exiting chat engine. Happy debugging!")
            break

        if not user_input:
            continue

        print("\n[Refining context, checking history and searching database...]\n")
        response = chat_engine.chat(user_input)

        print(f"Assistant:\n{response}\n")
        print("-" * 70)

    except (KeyboardInterrupt, EOFError):
        print("\nSession interrupted by user.")
        break