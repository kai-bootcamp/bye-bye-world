import { Grid, Box, Typography, Stack } from "@mui/material"
import Image from 'next/image'
import { useRouter } from "next/router"
import { getPetData } from '../data/pet'
import { Pet, Attributes } from '../interface/nft'
import PetProperties from '../components/pet/PetProperties'
import PetLevels from '../components/pet/PetLevels'

const PetDetail = () => {
  const router = useRouter()
  const { id } = router.query
  const petId = parseInt(id as string, 10)
  const pet = getPetData().find(item => item.id == petId)
  const properties: Attributes[] = []
  const levels: Attributes[] = []
  pet?.attributes.forEach(attr => {
    if (typeof attr.value == "number") {
      levels.push(attr)
    } else {
      properties.push(attr)
    }
  })
  return (
    <Box>
      {pet != undefined && (
        <Grid
          container
          justifyContent="center"
          alignContent="center"      
        >
          <Grid item xs={5}>
            <Box 
            border='rgba(112, 122, 131, 0.5) 1px solid'
            borderRadius="8px"
            overflow="hidden"
            display={'flex'}
            marginBottom="30px"
            >
              <Image
                src={pet.image}
                alt={pet.name}
                width={'700px'}
                height="700px" 
              />
            </Box>

            <Box
             borderRadius={3}
             border='rgb(112, 122, 131, 0.5) 1px solid'
             >
              <Stack>
                <Box>
                  <Typography variant="h3"> Description</Typography>
                  <Typography variant="h3"> {pet.description}</Typography>
                </Box>
                <PetProperties properties={properties} />
                <PetLevels levels={levels} />
              </Stack>
            </Box>


          </Grid>

          <Grid item xs={7}>
            <Box bgcolor="pink">
              <Image
                src={pet.image}
                alt={pet.name}
                width={400}
                height={400} />
            </Box>
          </Grid>

        </Grid>
      )}
    </Box>

  )


}

export default PetDetail