import Head from "next/head"
import Layout from "../../components/Layout"
import PetsPageContainer from '../../containers/PetsPageContainer'
import {getMintPets} from '../../contracts/wallet'
import {ethers} from "ethers"
import {useEffect, useState} from 'react'
import { id } from "ethers/lib/utils"


const PetsPage =  () => {

  const [reload, setReload] = useState(false)
  const [petIds, setPetIds] = useState<number[]>([])
  const [ownerList, setOwnerList] = useState<string[]>([])
  
  useEffect(() => {
    
    getMintPets()
      .then((result) => {
      const [idList, addressList] = result

      const formatIdList: number[] = []
      const formatAddressList: string[] = []
      for(var i = 0; i < idList.length; i ++){
        const id = idList[i]
        const address = addressList[i]
        if(id.toNumber() != 0){
            formatIdList.push(id.toNumber() as number)
            formatAddressList.push(address.toString() as string)
        }
      }

      setPetIds(formatIdList)
      setOwnerList(formatAddressList)

  
      setReload(true)
    }).catch(error => {console.log(error)})
  
  }, [reload])


  return (
    <Layout>
      <Head>
        <title>Pets | Kai</title>
      </Head>

      {reload && <PetsPageContainer petIds={petIds} ownerList={ownerList} />}
    </Layout>
  )
}

export default PetsPage