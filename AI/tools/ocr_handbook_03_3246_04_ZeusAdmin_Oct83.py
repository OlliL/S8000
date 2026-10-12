import pypdfium2 as pdfium
import pytesseract
from PIL import Image

def ocr_pdf_range_to_text(pdf_path, start_page=1, num_pages=None, lang='eng'):
    """
    Converts a specific page range of a PDF into text page by page using Tesseract OCR.

    :param pdf_path: Path to the PDF file
    :param start_page: First page to process (1-based index)
    :param num_pages: Number of pages to process (None = until the end)
    :param lang: Tesseract language code (e.g., 'eng', 'deu', 'eng+deu')
    """
    try:
        pdf = pdfium.PdfDocument(pdf_path)
    except Exception as e:
        print(f"Error opening PDF file: {e}")
        return ""

    total_pages = len(pdf)

    # Validate and constrain the range
    if start_page < 1:
        start_page = 1
    if start_page > total_pages:
        print(f"Start page {start_page} is out of bounds (Total pages: {total_pages}).")
        return ""

    # Calculate end page
    if num_pages is None:
        end_page = total_pages
    else:
        end_page = min(start_page + num_pages - 1, total_pages)

    full_text = []

    # pypdfium2 uses 0-based indexing internally (Index 0 = Page 1)
    start_idx = start_page - 1
    end_idx = end_page

    print(f"Processing pages {start_page} to {end_page} (out of {total_pages} total pages)...")

    for page_idx in range(start_idx, end_idx):
        page_number = page_idx + 1
        print(f"Reading and processing page {page_number}...")

        page = pdf[page_idx]

        # Render page at 300 DPI
        image = page.render(scale=300/72).to_pil()

        # Convert to grayscale for more stable OCR on 1-bit scans
        image_gray = image.convert('L')

        # Perform OCR (OEM 3: Default, PSM 6: Uniform block of text)
        custom_config = r'--oem 3 --psm 6'
        text = pytesseract.image_to_string(image_gray, lang=lang, config=custom_config)

        full_text.append(f"--- Page {page_number} ---\n{text}\n")

    return "\n".join(full_text)

if __name__ == "__main__":
    # Configuration
    pdf_file = "/mnt/users/olivleh1/BACKUPs/S8000/bitsavers/03-3246-04_ZeusAdmin_Oct83.pdf"
    output_file = "../ocr/03_3246_04__page_3_13.txt"

    # Define where to start and how many pages to process
    START_PAGE = 42   # E.g., start at page 1
    NUM_PAGES = 1    # E.g., process only the next 5 pages (Set to None for all remaining pages)

    extracted_text = ocr_pdf_range_to_text(
        pdf_path=pdf_file,
        start_page=START_PAGE,
        num_pages=NUM_PAGES,
        lang='eng'  # Set to 'eng' for English text
    )

    if extracted_text:
        with open(output_file, "w", encoding="utf-8") as f:
            f.write(extracted_text)
        print(f"\nDone! Text has been saved to '{output_file}'.")