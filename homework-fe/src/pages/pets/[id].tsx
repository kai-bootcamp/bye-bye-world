import Layout from '../../components/Layout'
import PetDetail from '../../containers/PetDetail'
import Head from 'next/head'

const PetDetailPage = () => {
  return (
    <Layout>
      <Head>
        <title>Pet details</title>
      </Head>

      <PetDetail/>
    </Layout>
  )

}

export default PetDetailPage