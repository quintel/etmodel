class Partner
  LEADING_PARTNERS = ['gasterra']

  attr_accessor :name, :key, :kind

  def initialize(attr_hash)
    attr_hash.symbolize_keys!
    attr_hash.each do |key,value|
      self.send("#{key}=", value)
    end
  end

  def self.all    
    items = []
    HTTParty.get("http://#{ $request.host_with_port =~ /dev/ ? 'etmodel.dev' : 'et-model.com' }/partners.json").parsed_response.each do |partner|
      items << self.new(partner)
    end
    items
  end

  def self.find(key)
    self.all.select { |p| p.key == key }.first
  end

  def self.primary
    let_leading_partners_lead(all.select(&:is_primary?).sort_by(&:name))
  end

  def self.knowledge
    let_leading_partners_lead(all.select(&:is_knowledge?).sort_by(&:name))
  end

  def self.education
    let_leading_partners_lead(all.select(&:is_education?).sort_by(&:name))
  end

  def is_primary?
    self.kind == 'primary'
  end

  def is_knowledge?
    self.kind == 'knowledge'
  end

  def is_education?
    self.kind == 'education'
  end

  def link
    "http://#{ $request.host_with_port =~ /dev/ ? 'etmodel.dev' : 'et-model.com' }/partners/#{ key }"
  end
  
  def footer_logo
    "http://#{ BUCKET_NAME }.s3.amazonaws.com/partners/#{ key }-inner.png"
  end

  #######
  private
  #######

  def self.let_leading_partners_lead(partners)
    leaders = partners.select {|partner| LEADING_PARTNERS.include?(partner.key) }
    leaders + (partners - leaders)
  end
end
