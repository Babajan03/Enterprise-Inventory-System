/* ===== Common DataTables Export & Utility Helpers ===== */

function getDTExportButtons(title, filename) {
    const exportTitle = title || "EIMS Data Export";
    const exportFilename = (filename || "eims_export_" + new Date().toISOString().slice(0,10)).toLowerCase().replace(/\s+/g, '_');

    return [
        {
            extend: 'excelHtml5',
            title: exportTitle,
            filename: exportFilename,
            className: 'btn btn-sm btn-outline-success border me-1',
            text: '<i class="bi bi-file-earmark-excel me-1"></i> Excel',
            exportOptions: { columns: ':not(:last-child)' }
        },
        {
            extend: 'pdfHtml5',
            title: exportTitle,
            filename: exportFilename,
            className: 'btn btn-sm btn-outline-danger border me-1',
            text: '<i class="bi bi-file-earmark-pdf me-1"></i> PDF',
            orientation: 'landscape',
            pageSize: 'A4',
            exportOptions: { columns: ':not(:last-child)' }
        },
        {
            extend: 'csvHtml5',
            title: exportTitle,
            filename: exportFilename,
            className: 'btn btn-sm btn-outline-primary border me-1',
            text: '<i class="bi bi-file-earmark-text me-1"></i> CSV',
            exportOptions: { columns: ':not(:last-child)' }
        },
        {
            extend: 'print',
            title: exportTitle,
            className: 'btn btn-sm btn-outline-secondary border me-1',
            text: '<i class="bi bi-printer me-1"></i> Print',
            exportOptions: { columns: ':not(:last-child)' }
        },
        {
            extend: 'copy',
            className: 'btn btn-sm btn-outline-dark border',
            text: '<i class="bi bi-clipboard me-1"></i> Copy',
            exportOptions: { columns: ':not(:last-child)' }
        }
    ];
}

const defaultDTDom = '<"d-flex flex-wrap align-items-center justify-content-between gap-2 mb-3"<"d-flex align-items-center gap-2"lB>f>rt<"d-flex justify-content-between align-items-center mt-3"ip>';
