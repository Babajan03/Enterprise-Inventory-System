from flask import Blueprint, jsonify, request
from flask_jwt_extended import jwt_required, get_jwt_identity

from services.purchase_service import PurchaseService
from services.notification_service import NotificationService
from services.audit_service import AuditService

purchase_approval_bp = Blueprint('purchase_approval', __name__)

@purchase_approval_bp.route('/purchase-approvals', methods=['GET'])
@jwt_required()
def list_pending_approvals():
    # Assuming status "Submitted" means pending approval
    pending = PurchaseService.get_by_status('Submitted')
    return jsonify(pending)

@purchase_approval_bp.route('/purchase-approvals/<int:po_id>/status', methods=['PUT'])
@jwt_required()
def approve_or_reject(po_id):
    data = request.get_json()
    decision = data.get('decision')  # Expected values: "Approved" or "Rejected"
    remarks = data.get('remarks')
    user_id = get_jwt_identity()

    if decision not in ('Approved', 'Rejected'):
        return jsonify({'error': 'Invalid decision'}), 400

    # Call service to handle approval logic
    success, message = PurchaseService.approve_purchase_order(
        po_id, user_id, decision, remarks
    )

    # Log audit
    AuditService.log_action(
        user_id,
        f'Purchase Order {decision}',
        f'PO ID {po_id}: {message}'
    )

    # Create notification for the PO creator (assumed stored in PO header)
    po = PurchaseService.get_by_id(po_id)
    if po:
        NotificationService.create_notification(
            po['CreatedBy'],
            f'Purchase Order {decision}',
            f'Your purchase order #{po["PurchaseOrderNumber"]} has been {decision.lower()}.'
        )

    return jsonify({'success': success, 'message': message})
