# How to Convert Documentation to PDF

## Option 1: Using Pandoc (Recommended - Command Line)

### Installation

#### On Linux/macOS:
```bash
# Using Homebrew (macOS)
brew install pandoc

# Using apt (Linux/Ubuntu)
sudo apt-get install pandoc

# Using package manager (Fedora)
sudo dnf install pandoc
```

#### On Windows:
```bash
# Using Chocolatey
choco install pandoc

# Or download from: https://pandoc.org/installing.html
```

### Conversion Command

```bash
# Navigate to project directory
cd /home/ltgwgeorge/Desktop/projects/esp32_security_app

# Convert single markdown file
pandoc APP_DOCUMENTATION.md -o ESP32_Security_App_Documentation.pdf

# Convert with custom styling
pandoc APP_DOCUMENTATION.md \
  -o ESP32_Security_App_Documentation.pdf \
  -f markdown \
  -t pdf \
  --toc \
  --toc-depth=2 \
  -V colorlinks=true \
  -V linkcolor=blue

# Combine multiple files into one PDF
pandoc START_HERE.md QUICK_START.md COMMANDS.md APP_DOCUMENTATION.md \
  -o ESP32_Security_Complete_Guide.pdf \
  --toc \
  --toc-depth=2
```

### Advanced Options

```bash
# With styling and formatting
pandoc APP_DOCUMENTATION.md \
  -o ESP32_Security_App_Documentation.pdf \
  -V geometry:margin=1in \
  -V fontsize=11pt \
  -V linestretch=1.5 \
  -V documentclass=article \
  --template /path/to/template.tex
```

---

## Option 2: Using VS Code Extension

### Installation

1. Open VS Code
2. Go to Extensions (Ctrl+Shift+X)
3. Search for "Markdown PDF"
4. Click "Install" by yzane

### Usage

1. Open `APP_DOCUMENTATION.md` in VS Code
2. Right-click anywhere in the editor
3. Select "Markdown PDF: Export (pdf)"
4. Choose location to save
5. PDF generated automatically

### Configure Extension

Create `.vscode/settings.json`:

```json
{
  "markdown-pdf.width": "8in",
  "markdown-pdf.height": "10.5in",
  "markdown-pdf.margin.top": "0.5in",
  "markdown-pdf.margin.right": "0.5in",
  "markdown-pdf.margin.bottom": "0.5in",
  "markdown-pdf.margin.left": "0.5in",
  "markdown-pdf.displayHeaderFooter": true,
  "markdown-pdf.headerTemplate": "<div style=\"font-size: 9px; margin: 0 auto;\">ESP32 Security App Documentation</div>",
  "markdown-pdf.footerTemplate": "<div style=\"font-size: 9px; margin: 0 auto;\"><span class=\"page\"></span> / <span class=\"totalPages\"></span></div>",
  "markdown-pdf.printBackground": true
}
```

---

## Option 3: Using Online Converter

### Step 1: Upload File

Go to any of these websites:
- https://markdowntopdf.com
- https://md2pdf.netlify.app
- https://stackedit.io (also has export)

### Step 2: Upload or Paste Content

1. Copy content from `APP_DOCUMENTATION.md`
2. Paste into the online converter
3. Or upload the file directly

### Step 3: Download PDF

1. Click "Export" or "Download"
2. Choose PDF format
3. Save to your computer

---

## Option 4: Using Google Docs

### Step 1: Create Document

1. Go to Google Docs (docs.google.com)
2. Create new document
3. Paste content from markdown file

### Step 2: Format

1. Let Google Docs auto-format
2. Adjust styling as needed
3. Add headers/footers if desired

### Step 3: Download as PDF

1. File → Download → PDF Document
2. Save to computer

---

## Option 5: Using Word/LibreOffice

### Step 1: Copy Content

1. Open `APP_DOCUMENTATION.md` in text editor
2. Copy all content

### Step 2: Paste into Word

1. Open Microsoft Word or LibreOffice
2. Paste content
3. Clean up formatting if needed

### Step 3: Export as PDF

**Microsoft Word**:
- File → Save As → Select PDF format

**LibreOffice**:
- File → Export as PDF

---

## Recommended Workflow

### Best Quality PDF (Pandoc + Custom Template)

```bash
# Step 1: Install Pandoc
brew install pandoc  # macOS
# or
sudo apt-get install pandoc  # Linux

# Step 2: Convert to PDF
cd /home/ltgwgeorge/Desktop/projects/esp32_security_app
pandoc APP_DOCUMENTATION.md \
  -o ESP32_Security_App_Documentation.pdf \
  --toc \
  --toc-depth=2 \
  -V geometry:margin=1in \
  -V fontsize=11pt \
  -V colorlinks=true \
  -V linkcolor=blue \
  --pdf-engine=xelatex

# Step 3: Verify
ls -lh ESP32_Security_App_Documentation.pdf
```

### Quick PDF (VS Code Extension)

```
1. Install Markdown PDF extension in VS Code
2. Open APP_DOCUMENTATION.md
3. Right-click → "Markdown PDF: Export (pdf)"
4. Save to desired location
```

### Fastest PDF (Online)

```
1. Go to https://markdowntopdf.com
2. Copy content from APP_DOCUMENTATION.md
3. Paste into converter
4. Click "Download PDF"
```

---

## Combining Multiple Files into One PDF

### Option A: Merge Markdown Files First

```bash
# Combine all markdown files
cat START_HERE.md QUICK_START.md COMMANDS.md APP_DOCUMENTATION.md > COMPLETE_GUIDE.md

# Convert to PDF
pandoc COMPLETE_GUIDE.md -o ESP32_Complete_Guide.pdf --toc
```

### Option B: Use Pandoc to Combine

```bash
# Pandoc can combine multiple files
pandoc START_HERE.md QUICK_START.md COMMANDS.md APP_DOCUMENTATION.md \
  -o ESP32_Complete_Guide.pdf \
  --toc \
  --toc-depth=2 \
  -V geometry:margin=1in
```

### Option C: Manual Merge in Word/Google Docs

1. Create new document in Word/Google Docs
2. Copy content from each markdown file
3. Insert page breaks between sections
4. Export as PDF

---

## File Organization After Conversion

### Recommended Structure

```
/home/ltgwgeorge/Desktop/projects/esp32_security_app/
├── PDF Documents/
│   ├── ESP32_Security_App_Documentation.pdf
│   ├── QUICK_START_Guide.pdf
│   ├── COMMANDS_Reference.pdf
│   └── Complete_Guide.pdf (all in one)
│
├── Markdown Files/
│   ├── APP_DOCUMENTATION.md
│   ├── QUICK_START.md
│   ├── COMMANDS.md
│   └── ... (other docs)
│
└── Source Code/
    ├── lib/
    ├── android/
    └── ios/
```

---

## Customizing PDF Output

### Pandoc Styling Options

```bash
# Larger margins
-V geometry:margin=1.5in

# Different page size
-V geometry:papersize=a4paper  # or letter, a5, b5

# Double spacing
-V linestretch=2

# Different font
-V mainfont="Times New Roman"
-V monofont="Courier New"

# Custom font size
-V fontsize=12pt

# Add page numbers
--pdf-engine-opt=-V pagebreak_translation=true

# Different layout
-V columns=2  # Two column layout
```

### Complete Example

```bash
pandoc APP_DOCUMENTATION.md \
  -o ESP32_Documentation.pdf \
  --toc \
  --toc-depth=3 \
  -V geometry:margin=1in \
  -V geometry:papersize=a4paper \
  -V fontsize=11pt \
  -V linestretch=1.5 \
  -V mainfont="DejaVu Sans" \
  -V monofont="DejaVu Sans Mono" \
  -V colorlinks=true \
  -V linkcolor=blue \
  -V urlcolor=blue \
  --pdf-engine=xelatex \
  --include-in-header=header.tex
```

---

## Troubleshooting PDF Conversion

### Problem: Pandoc not found

```bash
# Install Pandoc
brew install pandoc  # macOS
sudo apt-get install pandoc  # Linux/Ubuntu

# Verify installation
pandoc --version
```

### Problem: Special characters not displaying

```bash
# Use xelatex engine for better Unicode support
pandoc file.md -o output.pdf --pdf-engine=xelatex
```

### Problem: Table formatting broken

```bash
# Ensure table markdown is valid:
# Each table must have:
# - Header row with |
# - Separator row with |---|
# - Data rows with |
```

### Problem: Images not showing (if embedded)

```bash
# Ensure image paths are correct and relative
# Example: ![Alt text](./images/diagram.png)
```

### Problem: Very large PDF file

```bash
# Reduce file size with ghostscript
gs -sDEVICE=pdfwrite \
   -dCompatibilityLevel=1.4 \
   -dPDFSETTINGS=/ebook \
   -q -dNOPAUSE -dBATCH \
   -sOutputFile=output.pdf \
   input.pdf
```

---

## Verification Checklist

After creating PDF, verify:

- [ ] All text is readable
- [ ] Table of contents links work (if applicable)
- [ ] All code blocks are formatted correctly
- [ ] Images display properly (if any)
- [ ] Headers and footers appear (if configured)
- [ ] Page numbers are correct
- [ ] Links are clickable (if configured)
- [ ] No text is cut off at page edges
- [ ] Font is consistent throughout
- [ ] File size is reasonable (<20MB)

---

## Sharing the PDF

### Best Practices

1. **Version Number**: Include in filename
   - `ESP32_Documentation_v1.0.pdf`

2. **Date**: Add creation date
   - `ESP32_Documentation_2025-10-16.pdf`

3. **Compress**: For email sharing
   ```bash
   # On Linux/Mac
   gzip -9 ESP32_Documentation.pdf
   ```

4. **Host Online**: For easy sharing
   - Google Drive
   - GitHub Releases
   - Documentation site

---

## Quick Reference

### One-Line Conversions

```bash
# Simplest
pandoc APP_DOCUMENTATION.md -o output.pdf

# With table of contents
pandoc APP_DOCUMENTATION.md -o output.pdf --toc

# Professional
pandoc APP_DOCUMENTATION.md -o output.pdf --toc -V geometry:margin=1in -V fontsize=11pt

# Multiple files
pandoc *.md -o complete.pdf --toc

# Single file, quality preset
pandoc APP_DOCUMENTATION.md -o output.pdf --pdf-engine=xelatex --toc -V geometry:margin=1in
```

---

## Recommended Tools Summary

| Tool | Ease | Quality | Setup Time | Best For |
|------|------|---------|-----------|----------|
| Pandoc | Medium | Excellent | 5 min | Professional PDFs |
| VS Code Extension | Very Easy | Good | 2 min | Quick conversions |
| Online Converters | Very Easy | Good | 0 min | No setup needed |
| Google Docs | Very Easy | Good | 3 min | Collaborative |
| Word/LibreOffice | Very Easy | Fair | 2 min | Office users |

**Recommendation**: Use Pandoc for best results and professional quality.

---

## Next Steps

1. **Choose a conversion method** (Pandoc recommended)
2. **Run the conversion command**
3. **Verify the PDF output**
4. **Share or print as needed**
5. **Store the PDF safely**

---

**Document**: PDF Conversion Guide  
**Created**: October 16, 2025  
**Status**: Complete & Ready to Use
