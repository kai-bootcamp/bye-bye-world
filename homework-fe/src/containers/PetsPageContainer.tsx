import { Grid, Box, Stack, Typography } from "@mui/material"
import Image from "next/image"
import {useRouter}  from 'next/router'
import { getPetData } from "../data/pet"
import { Pet } from '../interface/nft'

const PetsPageContainer = () => {

  const pets = getPetData()
  const router = useRouter()
  return (
    <Box margin={1}>
      <Grid container spacing={3} justifyContent="center">
        {pets.map((pet: Pet) => (
          <Grid item xs="auto" key={pet.id}>
            <Box
              alignContent="center"
              onClick={() => router.push(`/pets/${pet.id}`)}
              bgcolor="#ddd"
              // display="flex"
              justifyContent="center"
              alignItems="center"
              // height={450}
            // width = {400}
            >
              <Image
                alt={pet.name}
                src={pet.image}
                height={400}
                width={400}
              />
              <Box justifyContent="center">
                <Typography variant='h5' color="black"  align="center" padding={1}> {pet.name}</Typography>
              </Box>
            </Box>
          </Grid>
        ))}
      </Grid>
    </Box>
  )
}

export default PetsPageContainer