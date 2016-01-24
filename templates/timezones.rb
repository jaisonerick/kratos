module ActiveSupport
  class TimeZone
    MAPPING.merge!('Noronha' => 'America/Noronha',
                   'Belém' => 'America/Belem',
                   'Fortaleza' => 'America/Fortaleza',
                   'Recife' => 'America/Recife',
                   'Araguaina' => 'America/Araguaina',
                   'Maceió' => 'America/Maceio',
                   'Campo Grande' => 'America/Campo_Grande',
                   'Cuiabá' => 'America/Cuiaba',
                   'Santarém' => 'America/Santarem',
                   'Porto Velho' => 'America/Porto_Velho',
                   'Boa Vista' => 'America/Boa_Vista',
                   'Manaus' => 'America/Manaus',
                   'Eirunepé' => 'America/Eirunepe',
                   'Rio Branco' => 'America/Rio_Branco')

    def self.br_zones
      @br_zones ||= all.find_all do |z|
        ['Noronha', 'Belém', 'Fortaleza', 'Recife', 'Araguaina', 'Maceió',
         'Campo Grande', 'Cuiabá', 'Santarém', 'Porto Velho', 'Boa Vista',
         'Manaus', 'Eirunepé', 'Rio Branco', 'Brasilia'].include?(z.name)
      end
    end
  end
end
