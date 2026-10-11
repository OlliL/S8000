import pdfplumber

def extract_pdf_layout_preserved(pdf_path, start_page=1, num_pages=None):
    """
    Extracts text from a searchable PDF while preserving visual layout and indentation
    using pdfplumber's layout mode.

    :param pdf_path: Path to the PDF file
    :param start_page: First page to process (1-based index)
    :param num_pages: Number of pages to process (None = until the end)
    """
    try:
        with pdfplumber.open(pdf_path) as pdf:
            total_pages = len(pdf.pages)

            if start_page < 1:
                start_page = 1
            if start_page > total_pages:
                print(f"Start page {start_page} is out of bounds (Total pages: {total_pages}).")
                return ""

            if num_pages is None:
                end_page = total_pages
            else:
                end_page = min(start_page + num_pages - 1, total_pages)

            full_text = []

            print(f"Extracting layout-preserved text from pages {start_page} to {end_page} (out of {total_pages})...")

            for page_num in range(start_page, end_page + 1):
                print(f"Processing page {page_num}...")

                # pdfplumber uses 0-based indexing for pages internally
                page = pdf.pages[page_num - 1]

                # layout=True maintains spatial positioning, spaces, and indentation
                text = page.extract_text(layout=True)

                if text:
                    full_text.append(f"--- Page {page_num} ---\n{text}\n")
                else:
                    full_text.append(f"--- Page {page_num} ---\n[No text found on this page]\n")

            return "\n".join(full_text)

    except Exception as e:
        print(f"Error opening or reading PDF file: {e}")
        return ""

if __name__ == "__main__":
    # Configuration
    pdf_file = "/mnt/users/olivleh1/BACKUPs/S8000/bitsavers/03-3198-01_System_8000_Hardware_Reference_Manual_Mar1982.pdf"
    output_file = "layout_preserved_result.txt"

    # Define page range
    START_PAGE = 199
    NUM_PAGES = 22

    extracted_text = extract_pdf_layout_preserved(
        pdf_path=pdf_file,
        start_page=START_PAGE,
        num_pages=NUM_PAGES
    )

    if extracted_text:
        with open(output_file, "w", encoding="utf-8") as f:
            f.write(extracted_text)
        print(f"\nDone! Layout-preserved text has been saved to '{output_file}'.")