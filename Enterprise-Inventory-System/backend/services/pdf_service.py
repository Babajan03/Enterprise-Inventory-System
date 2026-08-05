import os
from jinja2 import Environment, FileSystemLoader
from weasyprint import HTML

class PDFService:
    """Render HTML templates to PDF bytes using WeasyPrint.
    The templates live in the backend/templates directory.
    """
    @staticmethod
    def render(template_name: str, context: dict) -> bytes:
        # Set up Jinja2 environment pointing to the templates folder
        templates_path = os.path.join(os.path.dirname(__file__), '..', 'templates')
        env = Environment(loader=FileSystemLoader(templates_path))
        template = env.get_template(template_name)
        html_out = template.render(**context)
        # WeasyPrint converts HTML string to PDF bytes
        pdf = HTML(string=html_out).write_pdf()
        return pdf
