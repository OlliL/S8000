from llama_index.core import Settings, VectorStoreIndex, PromptTemplate
from llama_index.vector_stores.chroma import ChromaVectorStore
from lib.rag_config import db

print("Initializing Deep RAG Engine for Firmware Analysis...")

chroma_collection = db.get_collection("zilog_firmware")

# 4. Set up vector store and index
vector_store = ChromaVectorStore(chroma_collection=chroma_collection)
index = VectorStoreIndex.from_vector_store(
    vector_store, embed_model=Settings.embed_model
)

# 5. Configure query engine with deep analysis settings
# similarity_top_k=8 -> Fetches more code context for cross-checks
# response_mode="tree_summarize" -> Performs a deep, tree-like synthesis
query_engine = index.as_query_engine(
    similarity_top_k=8,
    response_mode="tree_summarize"
)

# 6. Tailored system / prompt template for hardware reverse engineering
expert_prompt = PromptTemplate(
    "You are a highly precise senior embedded software engineer and reverse engineer, specialized in Zilog architectures.\n"
    "Your task is to deeply analyze the provided assembly source code snippets.\n\n"
    "Observe the following rules in your answer:\n"
    "1. **Cross-Reference Check:** Examine how registers, flags, I/O ports, or memory addresses are used across different routines.\n"
    "2. **Logical Causality:** Explain not only *what* an instruction does, but *why* this step is necessary in the overall context of the firmware (e.g., handshakes, timing, interrupt handling).\n"
    "3. **Stick to Facts:** Do not invent registers or memory banks. If the code is incomplete, explicitly state so.\n\n"
    "Relevant code context from the database:\n"
    "---------------------\n"
    "{context_str}\n"
    "---------------------\n\n"
    "Question / Analysis task: {query_str}\n\n"
    "Detailed, technical analysis:"
)

# Register the prompt in the query engine
query_engine.update_prompts({"response_synthesizer:text_qa_template": expert_prompt})

# 7. Interactive loop
print("=== Z8000 Deep Firmware Analyzer (Mode: Max Depth & Cross-Check) ===")
print("Type your question (or 'exit' to quit).\n")

while True:
    try:
        question = input("Analytical question to the firmware: ").strip()

        if question.lower() in ["exit", "quit", "q"]:
            print("Exiting analyzer. Happy debugging!")
            break

        if not question:
            continue

        print("\n[Analyzing source code, cross-referencing, and synthesizing answer...]\n")
        response = query_engine.query(question)

        print(f"Result:\n{response}\n")
        print("=" * 70)

    except (KeyboardInterrupt, EOFError):
        print("\nAborted by user.")
        break