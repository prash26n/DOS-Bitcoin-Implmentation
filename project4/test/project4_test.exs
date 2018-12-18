defmodule Project4Test do
  use ExUnit.Case
  doctest Project4
  
         test "Generate genesis block" do
          z = Project4.initBlock()
          assert elem(z,2) == ""
		end
		
        test "check if wallet generated key validates signature" do
          #generate addresses (holds transaction records)
          {pub1,pvt1} = Wallet.Key.gen() #generate keypair for wallet1
          {pub2,pvt2} = Wallet.Key.gen() #generate keypair for wallet2

          #get address from private keys
          addr1 = Wallet.Addr.agen(pvt1)
          addr2 = Wallet.Addr.agen(pvt2)

          #transaction
          #digital signature from pvt key, receiver, and bitcoin value
          msg = "5"
          sig1 = Wallet.Addr.gen(pvt1, msg)

          #verify sig1 comes from pub1
          assert Wallet.Addr.validate(pub1,sig1,msg) == true
		  end

         test "create private key and check if properly gets the public" do
          {pub1,pvt1} = Wallet.Key.gen()

          pubx = Wallet.Key.pvt2pub(pvt1)

          assert pub1 == pubx
		end

          test "verify mining of block with a transaction (difficulty value of 4)" do
          {pub1,pvt1} = Wallet.Key.gen()
          {pub2,pvt2} = Wallet.Key.gen()

          msg = "message"
          sig1 = Wallet.Addr.gen(pvt1, msg)
          to = Wallet.Addr.agen(pvt2)
		  time = NaiveDateTime.utc_now
          utxo = [5,to,pub1,sig1,time]
          hash = Project4.Server.mine_utxo_test(utxo)
          assert (String.slice(hash,0,4) == String.duplicate("0",4)) 
		end
		
end
