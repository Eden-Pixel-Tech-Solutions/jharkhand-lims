import re

# Input file
input_file = "LAB INTEGRATION CDAC Meril.txt"

# Output file
output_file = "cleaned_output.txt"

# Regex to remove base64 PDF content
pattern = r'"poct_pdf_rpt_base64"\s*:\s*"(.*?)"'

with open(input_file, "r", encoding="utf-8", errors="ignore") as f:
    content = f.read()

# Replace base64 content with placeholder
cleaned_content = re.sub(
    pattern,
    '"poct_pdf_rpt_base64": "[REMOVED_BASE64_CONTENT]"',
    content,
    flags=re.DOTALL
)

with open(output_file, "w", encoding="utf-8") as f:
    f.write(cleaned_content)

print("Base64 content removed successfully.")
print(f"Cleaned file saved as: {output_file}")