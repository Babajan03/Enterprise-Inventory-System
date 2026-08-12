/* ===== Common DataTables Export & Utility Helpers ===== */

function getDTExportButtons(title, filename) {
    const exportTitle = title || "EIMS Data Export";
    const exportFilename = (filename || "eims_export_" + new Date().toISOString().slice(0,10)).toLowerCase().replace(/\s+/g, '_');

    return [
        {
            extend: 'excelHtml5',
            title: exportTitle,
            filename: exportFilename,
            className: 'btn btn-sm btn-success text-white me-1 fw-semibold shadow-sm',
            text: '<i class="bi bi-file-earmark-excel-fill me-1"></i> Excel',
            exportOptions: { columns: ':not(:last-child)' }
        },
        {
            extend: 'pdfHtml5',
            title: exportTitle,
            filename: exportFilename,
            className: 'btn btn-sm btn-danger text-white me-1 fw-semibold shadow-sm',
            text: '<i class="bi bi-file-earmark-pdf-fill me-1"></i> PDF',
            orientation: 'landscape',
            pageSize: 'A4',
            exportOptions: { columns: ':not(:last-child)' }
        },
        {
            extend: 'csvHtml5',
            title: exportTitle,
            filename: exportFilename,
            className: 'btn btn-sm btn-primary text-white me-1 fw-semibold shadow-sm',
            text: '<i class="bi bi-file-earmark-text-fill me-1"></i> CSV',
            exportOptions: { columns: ':not(:last-child)' }
        },
        {
            extend: 'print',
            title: exportTitle,
            className: 'btn btn-sm btn-secondary text-white me-1 fw-semibold shadow-sm',
            text: '<i class="bi bi-printer-fill me-1"></i> Print',
            exportOptions: { columns: ':not(:last-child)' }
        },
        {
            extend: 'copy',
            className: 'btn btn-sm btn-dark text-white me-1 fw-semibold shadow-sm',
            text: '<i class="bi bi-clipboard-fill me-1"></i> Copy',
            exportOptions: { columns: ':not(:last-child)' }
        }
    ];
}

// Bootstrap 5 DataTables DOM layout string
const defaultDTDom = '<"row mb-3 align-items-center"<"col-md-6 d-flex align-items-center gap-2"lB><"col-md-6"f>>' +
                     '<"row"<"col-12"tr>>' +
                     '<"row mt-3 align-items-center"<"col-md-6"i><"col-md-6 d-flex justify-content-end"p>>';

/**
 * Robust DataTables Manager - Updates existing table cleanly without DOM destruction
 * or initializes a new DataTable with full pagination and page length controls.
 */
function updateOrInitDataTable(tableSelector, existingInstance, data, columns, options = {}) {
    if ($.fn.DataTable.isDataTable(tableSelector) && existingInstance) {
        existingInstance.clear();
        existingInstance.rows.add(data);
        existingInstance.draw(false);
        return existingInstance;
    } else {
        if ($.fn.DataTable.isDataTable(tableSelector)) {
            $(tableSelector).DataTable().destroy();
        }
        const defaultConfig = {
            data: data,
            columns: columns,
            responsive: true,
            pageLength: 10,
            lengthMenu: [[10, 20, 50, 100, -1], [10, 20, 50, 100, "All"]],
            dom: defaultDTDom,
            order: [[0, 'desc']],
            ...options
        };
        return $(tableSelector).DataTable(defaultConfig);
    }
}
