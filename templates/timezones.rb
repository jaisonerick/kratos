module ActiveSupport
  class TimeZone
    MAPPING['Noronha'] = 'America/Noronha'
    MAPPING['Belém'] = 'America/Belem'
    MAPPING['Fortaleza'] = 'America/Fortaleza'
    MAPPING['Recife'] = 'America/Recife'
    MAPPING['Araguaina'] = 'America/Araguaina'
    MAPPING['Maceió'] = 'America/Maceio'
    MAPPING['Campo Grande'] = 'America/Campo_Grande'
    MAPPING['Cuiabá'] = 'America/Cuiaba'
    MAPPING['Santarém'] = 'America/Santarem'
    MAPPING['Porto Velho'] = 'America/Porto_Velho'
    MAPPING['Boa Vista'] = 'America/Boa_Vista'
    MAPPING['Manaus'] = 'America/Manaus'
    MAPPING['Eirunepé'] = 'America/Eirunepe'
    MAPPING['Rio Branco'] = 'America/Rio_Branco'

    def self.br_zones
      @br_zones ||= all.find_all do |z|
        ['Noronha', 'Belém', 'Fortaleza', 'Recife', 'Araguaina', 'Maceió',
         'Campo Grande', 'Cuiabá', 'Santarém', 'Porto Velho', 'Boa Vista',
         'Manaus', 'Eirunepé', 'Rio Branco', 'Brasilia'].include?(z.name)
      end
    end
  end
end
