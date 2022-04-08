
export interface Attributes {
  trait_type: string
  value: string | number
}

export interface Pet {
  id: number,
  name: string
  image: string
  description: string
  attributes: Attributes[]
}