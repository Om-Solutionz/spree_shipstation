# frozen_string_literal: true

xml = Builder::XmlMarkup.new
xml.instruct!
xml.Orders {
  @orders.each do |order|
    # order = shipment.order

    xml.Order {
      xml.version '1.0'
      xml.rectype 'B'
      xml.seqno '1'
      xml.ordno order.number
      xml.webtrack order.number
      xml.orddate order&.completed_at&.strftime(SpreeShipstation::ExportHelper::DATE_FORMAT)
      xml.email order.email
      xml.program order&.store&.name
      xml.ordcust ''
      xml.bcompany 'TRM'
      xml.battn ''
      xml.baddr1 order&.bill_address&.address1
      xml.baddr2 order&.bill_address&.address2
      xml.bcity order&.bill_address&.city
      xml.bstate order&.bill_address&.state&.name
      xml.bzip order&.bill_address&.zipcode
      xml.bcountry order&.bill_address&.country&.name
      xml.bphone order&.bill_address&.phone
      xml.shipdesc order&.shipments&.first&.shipping_methods&.first&.name

      xml.shiptos {
        xml.shipto {
          xml.rectype 'S'
          xml.seqno '1'
          xml.ordno order.number
          xml.webtrack order.number
          xml.shipdate order&.shipments&.first&.created_at&.strftime(SpreeShipstation::ExportHelper::DATE_FORMAT)
          xml.sname order&.ship_address&.firstname
          xml.saddr1 order&.ship_address&.address1
          xml.saddr2 order&.ship_address&.address2
          xml.scity order&.ship_address&.city
          xml.sstate order&.ship_address&.state&.name
          xml.szip order&.ship_address&.zipcode
          xml.scountry order&.ship_address&.country&.name
          xml.sphone order&.ship_address&.phone
          xml.shipdesc order&.shipments&.first&.shipping_methods&.first&.name
        }
      }
      xml.Items {
        order.line_items.each do |line|
          variant = line.variant
          xml.Item {
            xml.rectype 'I'
            xml.seqno '1'
            xml.ordno order.number
            xml.webtrack order.number
            xml.itemno ''
            xml.subno ''
            xml.itemcustno ''
            xml.Quantity line.quantity
            xml.taxable order.taxable_adjustment_total.present? ? 'Y' : 'N'
            # xml.UnitPrice line.price
            # if variant.option_values.present?
            #   xml.Options {
            #     variant.option_values.each do |value|
            #       xml.Option {
            #         xml.Name value.option_type.presentation
            #         xml.Value value.name
            #       }
            #     end
            #   }
            # end
          }
        end
      }
      xml.instructions {
        xml.rectype 'C'
        xml.seqno '1'
        xml.ordno order.number
        xml.payment order&.payments&.first&.payment_method&.name
      }
    }
  end
}
