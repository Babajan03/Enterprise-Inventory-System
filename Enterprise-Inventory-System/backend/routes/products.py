from flask import Blueprint, jsonify, request

from services.product_service import ProductService

products_bp = Blueprint(
    "products",
    __name__,
    url_prefix="/products"
)


@products_bp.get("/")
def get_all_products():

    return jsonify(
        ProductService.get_all()
    )


@products_bp.get("/<int:product_id>")
def get_product(product_id):

    product = ProductService.get_by_id(product_id)

    if not product:
        return jsonify(
            {
                "success": False,
                "message": "Product not found"
            }
        ),404

    return jsonify(product)


@products_bp.post("/")
def add_product():

    ProductService.add(request.json)

    return jsonify(
        {
            "success": True,
            "message": "Product Added Successfully"
        }
    )


@products_bp.put("/<int:product_id>")
def update_product(product_id):

    ProductService.update(
        product_id,
        request.json
    )

    return jsonify(
        {
            "success": True,
            "message": "Product Updated Successfully"
        }
    )


@products_bp.delete("/<int:product_id>")
def delete_product(product_id):

    ProductService.delete(product_id)

    return jsonify(
        {
            "success": True,
            "message": "Product Deleted Successfully"
        }
    )


@products_bp.post("/search")
def search_product():

    return jsonify(
        ProductService.search(request.json)
    )