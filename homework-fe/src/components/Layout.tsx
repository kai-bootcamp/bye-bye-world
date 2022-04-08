import { Toolbar, Box } from "@mui/material"


const Layout = ({ children }: { children: any }) => {
  return (
    <Box sx={{display: 'flex'}} alignItems="center" justifyContent="center">
      <Box
        component="main"
        sx={{
          flexGrow: 1,
          bgcolor: 'background.default',
          width: { sm: "calc(100% - 500px" },
          ml: { sm: '500px' }
        }}>
        <Toolbar />
        {children}
      </Box>
    </Box>

  )
}

export default Layout