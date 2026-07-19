let productTable;

async function loadProducts() {

    if ($.fn.DataTable.isDataTable("#productTable")) {

        productTable.destroy();

    }

    const response =
        await fetch(API_BASE + "/products/");

    const data =
        await response.json();

    productTable =
        $("#productTable").DataTable({

            data: data,

            responsive: true,

            columns: [

                { data: "ProductCode" },

                { data: "ProductName" },

                { data: "CategoryName" },

                { data: "BrandName" },

                {
                    data: "SellingPrice",

                    render: function (value) {

                        return "₹ " + value;

                    }

                },

                { data: "MinimumStock" },

                { data: "ReorderLevel" },

                {

                    data: "IsActive",

                    render: function (value) {

                        if (value)

                            return `<span class="badge bg-success">

                            Active

                            </span>`;

                        return `<span class="badge bg-danger">

                        Inactive

                        </span>`;

                    }

                },

                {

                    data: null,

                    render: function (row) {

                        return `

<button

class="btn btn-warning btn-sm"

onclick="editProduct(${row.ProductID})">

Edit

</button>

<button

class="btn btn-danger btn-sm ms-1"

onclick="deleteProduct(${row.ProductID})">

Delete

</button>

`;

                    }

                }

            ]

        });

}