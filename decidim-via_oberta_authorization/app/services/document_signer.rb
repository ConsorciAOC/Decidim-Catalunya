require 'signer'

class DocumentSigner
  def initialize(document:, certificate:, private_key_cert:, private_key_pass:)
    @document = document
    @certificate = certificate
    @private_key_cert = private_key_cert
    @private_key_pass = private_key_pass
  end 

  def sign_document
    signer = Signer.new(@document)
    
    signer.cert = OpenSSL::X509::Certificate.new(@certificate)
    signer.private_key = OpenSSL::PKey::RSA.new(@private_key_cert, @private_key_pass)
    signer.security_node = signer.document.root
    
    signer.document.xpath("//u:Timestamp", { "u" => "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" }).each do |node|
      signer.digest!(node)
    end
  
    signer.document.xpath("//a:To", { "a" => "http://www.w3.org/2005/08/addressing" }).each do |node|
      signer.digest!(node)
    end
  
    signer.sign!(:security_token => true)
    
    signer.to_xml
  end
end
