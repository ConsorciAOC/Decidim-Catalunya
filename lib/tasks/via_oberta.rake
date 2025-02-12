# frozen_string_literal: true

#
# A set of utils to manage and validate verification related data.
#
namespace :via_oberta do
  desc "Checks the given credentials against Via Oberta (document_type nif/passport/residence_card/nie)"
  task :check, [:org_id, :document_type, :id_document] => :environment do |_task, args|
    organization = Decidim::Organization.find(args.org_id)
    document_type = args.document_type
    id_document = args.id_document

    puts <<~EOMSG
      Performing request with parameters:
      document_type: #{ViaObertaAuthorizationConfig::DOCUMENT_TYPE[document_type]}
      id_document: #{id_document}
    EOMSG

    puts "\nRESPONSE:"
    service = ViaObertaAuthorizationRq.new(organization)
    rs = service.send_rq(
      document_type: ViaObertaAuthorizationConfig::DOCUMENT_TYPE[document_type],
      id_document: id_document
    )
    puts "RS: #{rs.body}"
    puts "Extracted RS: #{parse_response(rs)}"
  end

  def parse_response(response)
    # The *real* response data is encoded as a xml string inside a xml node.
    parsed = Nokogiri::XML(response.body).remove_namespaces!
    Nokogiri::XML(parsed.xpath("//procesaResponse")[0])
  end

  desc "Returns the ViaObertaAuthorizationHandler encoded version of the document argument"
  task :to_unique_id, [:document] => :environment do |_task, args|
    puts to_unique_id(args.document)
  end

  desc "Is there a Decidim::Authorization for the given document"
  task :find_authorization_by_doc, [:document] => :environment do |_task, args|
    authorization = Decidim::Authorization.find_by(unique_id: to_unique_id(args.document))
    puts authorization
  end

  def to_unique_id(document)
    Digest::SHA256.hexdigest("#{document}-#{Rails.application.secrets.secret_key_base}")
  end
end
