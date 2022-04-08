import Head from "next/head"
import Layout from "../../components/Layout"
import PetsPageContainer from '../../containers/PetsPageContainer'

const PetsPage = () => {
  return (
    <Layout>
      <Head>
        <title>Pets | Kai</title>
      </Head>

      <PetsPageContainer/>
    </Layout>
  )
}

export default PetsPage