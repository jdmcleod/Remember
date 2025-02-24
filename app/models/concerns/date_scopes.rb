module DateScopes
  extend ActiveSupport::Concern

  included do
    scope :in_range, -> (query_start_date, query_end_date) do
      where(arel_table[:date].gteq(query_start_date)).where(arel_table[:date].lteq(query_end_date)).order(arel_table[:date])
    end

    scope :range_in_range, -> (query_start_date, query_end_date) do
      where(arel_table[:start_date].gteq(query_start_date)).where(arel_table[:start_date].lteq(query_end_date))
    end

    scope :contains_date, -> (date) do
      where(arel_table[:start_date].lteq(date)).where(arel_table[:end_date].gteq(date))
    end
  end
end
