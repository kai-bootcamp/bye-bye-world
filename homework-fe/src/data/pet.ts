import { PendingActionsRounded } from '@mui/icons-material'
import {Pet} from '../interface/nft'

const uri = 'https://petshop-project.s3.ap-southeast-1.amazonaws.com/'

export const getPetData = (petIds: number[], ownerList: string[]):Pet[] => {
  const petSize = 30
  const pets = []
  for (var i = 1; i <= petSize; i++) {
    const pet: Pet =
    {
      id: i,
      name: `Pet #${i}`,
      image: `${uri}${i}.png`,
      description: `Pet ...${i}`,
      attributes: [
        { trait_type: "Eye", value: "Hearty Purple Radiant Eyes" },
        { trait_type: "Hair", value: "Reckless Flaming Hair" },
        { trait_type: "Mouth", value: "Ancient Sea Fish" },
        { trait_type: "Weapon", value: "Naughty Girl Fun Spray" },
        { trait_type: "Costume", value: "Absolute Scarlet Armor" },
        { trait_type: "Background", value: "Urban Ninja Camouflage" },
        { trait_type: "HP", value: 23 },
        { trait_type: "Attack", value: 12 },
        { trait_type: "Intel", value: 3 }
      ]
    }

    var index = petIds.indexOf(pet.id)
    if(index >=0 ){
      const owner = ownerList[index]
      pets.push({...pet, owner})
    }
  
  }

  console.log("pets----------", pets)

  return pets
}


