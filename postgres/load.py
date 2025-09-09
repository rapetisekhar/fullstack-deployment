import PyPDF2
import psycopg2

PDF_FILE = "sample.pdf"

# Extract text from PDF
with open(PDF_FILE, "rb") as f:
    reader = PyPDF2.PdfReader(f)
    text = " ".join([page.extract_text() for page in reader.pages if page.extract_text()])

# Connect to PostgreSQL
conn = psycopg2.connect(
    dbname="postgres",
    user="postgres",
    password="password",
    host="postgres-haproxy",  # Kubernetes service name
    port="5432"
)

cur = conn.cursor()

# Create table if it doesn’t exist
cur.execute("""
CREATE TABLE IF NOT EXISTS pdf_texts (
    id SERIAL PRIMARY KEY,
    name TEXT,
    content TEXT
);
""")

# Insert PDF content
cur.execute("INSERT INTO pdf_texts (name, content) VALUES (%s, %s)", (PDF_FILE, text))

conn.commit()
cur.close()
conn.close()

print("✅ PDF data inserted into Postgres")

