# @summary list of keywords that support negation
type Ferm::Negation = Variant[
  Array[Ferm::Negation],
  Enum[
    'saddr',
    'daddr',
    'sport',
    'dport',
    'src_set',
    'dst_set',
  ],
]
