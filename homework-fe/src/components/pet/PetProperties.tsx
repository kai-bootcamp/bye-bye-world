import { Grid, Box, Typography, Stack, Button } from "@mui/material"
import { Attributes } from "../../interface/nft"
import { KeyboardArrowDown, KeyboardArrowUp } from '@mui/icons-material';
import { Accordion, AccordionSummary, AccordionDetails } from '@material-ui/core';
import { makeStyles } from '@mui/styles'

const useStyles = makeStyles(() => ({
  accordion: {
    backgroundColor: "white !important",
    borderRadius: "0px !important",
    borderTop: "rgb(225, 229, 232) 1px solid !important",

  },
  accordion_summary: {
    backgroundColor: "white !important",
    borderBottom: "rgb(225, 229, 232) 1px solid !important",
    borderRadius: "0px !important",
  },
  accordion_detail: {
    backgroundColor: "rgb(250, 253, 255) !important",
    padding: "0px !important",
    margin: "0px !important",
    borderBottom: "rgb(225, 229, 232) 1px solid !important",

  },
}))

const PetProperties = (props: { properties: Attributes[] }) => {
  const { properties } = props
  const classes = useStyles()

  return (
    <Box>
      <Accordion classes={{ root: classes.accordion }}
      >
        <AccordionSummary
          classes={{ root: classes.accordion_summary }}
          expandIcon={<KeyboardArrowDown />}
        >
          <Typography>Properties</Typography>
        </AccordionSummary>

        <AccordionDetails
          className={classes.accordion_detail}
        >
          <Grid container
            justifyContent='center'
            alignContent="center"
            justifyItems="center"
            padding={2}
            rowGap={2}
            columnGap={2}
          >
            {
              properties.map((item, index) => {
                return (
                  <Grid key={index} item xs="auto" >
                    <Box
                      bgcolor="rgb(236, 248, 253)"
                      border="rgb(21, 185, 229) 1px solid"
                      borderRadius={2}
                    >
                      <Stack
                        minHeight="80px"
                        justifyContent="center"
                        justifyItems="center"
                        alignContent="center"
                        width="150px"
                        padding="2px"
                      >
                        <Typography align="center" fontSize="12px" fontWeight={530} color="rgb(21, 169, 255)">{item.trait_type.toUpperCase()}</Typography>
                        <Typography align="center" fontSize="12px" color="rgb(47, 49, 56)">{item.value}</Typography>
                      </Stack>
                    </Box>
                  </Grid>
                )
              })
            }
          </Grid>
        </AccordionDetails>
      </Accordion>
    </Box>
  )
}

export default PetProperties