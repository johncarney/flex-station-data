module FlexStationData
  class DefaultSampleMap
    attr_reader :rows, :columns, :wells_per_sample

    def initialize(rows, columns, wells_per_sample)
      @rows             = rows
      @columns          = columns
      @wells_per_sample = wells_per_sample
    end

    def [](sample_label)
      sample_label = Integer(sample_label)
      map[sample_label] ||= map_sample(sample_label)
    end

    private

    def map_sample(sample_label)
      column, row = (sample_label - 1).divmod(rows)
      row_label = ("A".ord + row).chr
      base_column = (column * wells_per_sample) + 1
      (0...wells_per_sample).map do |column_offset|
        [ row_label, base_column +column_offset ].join("")
      end
    end

    def map
      @map ||= {}
    end
  end
end
