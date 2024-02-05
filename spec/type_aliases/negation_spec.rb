# frozen_string_literal: true

require 'spec_helper'

describe 'Ferm::Negation' do
  describe 'valid values' do
    valid_values = %w[saddr daddr sport dport src_set dst_set]

    [
      [valid_values], # Array[Ferm::Negation]
      valid_values, # Enum
    ].each do |value|
      describe value.inspect do
        it { is_expected.to allow_value(value) }
      end
    end
  end

  describe 'invalid values' do
    context 'with garbage inputs' do
      [
        'RETURN',
        'REJECT',
        'foobar',
        :symbol,
        nil,
        '',
        true,
        false,
        %w[meep meep],
        65_538,
        [95_000, 67_000],
        {},
        { 'foo' => 'bar' },
      ].each do |value|
        describe value.inspect do
          it { is_expected.not_to allow_value(value) }
        end
      end
    end
  end
end
