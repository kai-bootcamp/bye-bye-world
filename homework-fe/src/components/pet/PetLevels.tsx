import { Grid, Box, Typography, Stack, LinearProgress , Accordion, AccordionSummary, AccordionDetails} from "@mui/material"
import { Attributes } from '../../interface/nft'
import { KeyboardArrowDown, ExpandMore } from "@mui/icons-material"
import { makeStyles } from "@mui/styles"

const MIN = 0
const MAX = 50

const normalise = (value: number): number => ((value - MIN) * 100) / (MAX - MIN)

const useStyles = makeStyles(() => ({
  accordion: {
    backgroundColor: "white !important",
    borderRadius: "0px !important",
    borderBottomLeftRadius: "18px !important",
    borderBottomRightRadius: "18px !important",
  },
  accordion_summary: {
    backgroundColor: "red important",
    borderRadius: "0px !important",
    borderBottom: "rgb(225, 229, 232) 1px solid !important",

  },
  accordion_detail: {
    backgroundColor: "rgb(250, 253, 255) !important",
    padding: "0px !important",
    margin: "0px !important",
    borderBottomLeftRadius: "18px !important",
    borderBottomRightRadius: "18px !important",
  },
  line_progress: {
    height: "18px !important",
    borderRadius: "50px !important"
  }
}))

const PetLevels = (props: { levels: Attributes[] }) => {
  const { levels } = props
  const classes = useStyles()

  return (
    <Box>
      <Accordion classes={{root:classes.accordion}}>
        <AccordionSummary expandIcon={<ExpandMore />} classes={{root:classes.accordion_summary}}>
          <Typography>Levels</Typography>
        </AccordionSummary>
        <AccordionDetails classes={{root: classes.accordion_detail}}>
          <Stack direction="column" width="100%" padding="30px 20px 20px 20px">
            {levels.map((item, index) => {
              const value = parseInt(item.value as string, 10)
              return (
                <Stack key={index} direction="column" paddingBottom="0px" >
                  <Box display="flex" justifyContent="space-between" >
                    <Typography
                      paddingBottom={1}
                      color="rgb(112, 122, 131)"
                      fontWeight={500}
                    >{item.trait_type}</Typography>
                    <Typography
                       color="rgb(112, 122, 131)"
                       fontWeight={500}
                    >{value} of {MAX}</Typography>
                  </Box>
                  <Box padding="4px 4px 30px 4px">
                    <LinearProgress
                      className={classes.line_progress}
                      variant="determinate"
                      value={normalise(value)}
                    />
                  </Box>
                </Stack>
              )
            })}
          </Stack>
        </AccordionDetails>
      </Accordion>

    </Box>
  )
}

export default PetLevels;