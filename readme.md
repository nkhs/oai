---------------------
Other Reference
1. https://open-cells.com/index.php/2017/06/07/openair-single-machine-ubuntu-17-04-after-major-epc-update/

2. https://github.com/OPENAIRINTERFACE/openair-cn/issues/39


diff --git a/src/hss_rel14/src/s6as6d_impl.cpp b/src/hss_rel14/src/s6as6d_impl.cpp
index 6a97bbc6..615e3d0d 100755
--- a/src/hss_rel14/src/s6as6d_impl.cpp
+++ b/src/hss_rel14/src/s6as6d_impl.cpp
@@ -653,7 +653,7 @@ req->dump();
         }
 
         if (auts_set) {
-            sqn = sqn_ms_derive_cpp (imsisec.opc, imsisec.key, auts, imsisec.rand);
+            sqn = sqn_ms_derive_cpp (imsisec.opc, imsisec.key, auts + 16, imsisec.rand);
             if (sqn != NULL) {
 
               //We succeeded to verify SQN_MS...


3. https://chancetarver.com/oai/fixes/
 WRR_LIST_SELECTION = (
        {ID="tac-lb01.tac-hb00.tac.epc.mnc092.mcc208.3gppnetwork.org" ;      SGW_IPV4_ADDRESS_FOR_S11="172.16.1.114/24";}
    );

4. https://github.com/OPENAIRINTERFACE/openair-cn-cups/issues/4
No need more: Speed is slow

5.https://gloiremao.gitbooks.io/oai-tutorial/content/chapter3.html
 /openair-cn/UTILS/mcc_mnc_itu.c
const mcc_mnc_list_t  mcc_mnc_list[]={
{466,”68”}   ###<- add this entry
…..
}

./NAS/MME/EMM/SAP/emm_send.c:186: In emm_send_attach_accept() function, replace this line
emm_msg->epsattachresult = EPS_ATTACH_RESULT_EPS;
with 
emm_msg->epsattachresult = EPS_ATTACH_RESULT_EPS_IMSI;


---------------------


./data_provisioning_users --apn oai.ng4T.com --apn2 internet --key fec86ba6eb707ed08905757b1bb44b8f --imsi-first 0467070000000001 --msisdn-first 001011234561000 --mme-identity mme.ng4T.com --no-of-users 2 --realm ng4T.com --truncate True  --verbose True --cassandra-cluster $Cassandra_Server_IP

./data_provisioning_mme --id 3 --mme-identity mme.ng4T.com --realm ng4T.com --ue-reachability 1 --truncate True  --verbose True -C $Cassandra_Server_IP



------------------------------------- Create HSS configuration files---------------------------------------------
# prompt has been removed for easier Ctrl+C Ctrl+V
# cd $OPENAIRCN_DIR/scripts

openssl rand -out $HOME/.rnd 128

PREFIX='/usr/local/etc/oai'
sudo mkdir -m 0777 -p $PREFIX
sudo mkdir -m 0777    $PREFIX/freeDiameter
# freeDiameter configuration files
cp ../etc/acl.conf ../etc/hss_rel14_fd.conf $PREFIX/freeDiameter
cp ../etc/hss_rel14.conf ../etc/hss_rel14.json $PREFIX

declare -A HSS_CONF
HSS_CONF[@PREFIX@]=$PREFIX
HSS_CONF[@REALM@]='ng4T.com'
HSS_CONF[@HSS_FQDN@]="hss.${HSS_CONF[@REALM@]}"
HSS_CONF[@cassandra_Server_IP@]='127.0.0.1'
HSS_CONF[@OP_KEY@]='1006020f0a478bf6b699f15c062e42b3'
HSS_CONF[@ROAMING_ALLOWED@]='true'
HSS_CONF[@cassandra_Server_IP@]='127.0.0.1'

for K in "${!HSS_CONF[@]}"; do 
  egrep -lRZ "$K" $PREFIX | xargs -0 -l sed -i -e "s|$K|${HSS_CONF[$K]}|g"
done

### freeDiameter certificate
../src/hss_rel14/bin/make_certs.sh hss ${HSS_CONF[@REALM@]} $PREFIX

# Finally customize the listen address of FD server
# set in $PREFIX/freeDiameter/hss_rel14_fd.conf and uncomment the following line
sed -i -e 's/#ListenOn/ListenOn/g' $PREFIX/freeDiameter/hss_rel14_fd.conf 

--------------------------------------------------------------------------------------------------------------
oai_hss -j $PREFIX/hss_rel14.json --onlyloadkey
--------------------------------------- Create MME configuration files --------------------------------------------	
# prompt has been removed for easier Ctrl+C Ctrl+V
openssl rand -out $HOME/.rnd 128
# cd $OPENAIRCN_DIR/scripts
# S6a
sudo ifconfig enp2s0:m11 172.16.1.102 up
sudo ifconfig enp2s0:m1c 192.168.247.102 up
INSTANCE=1
PREFIX='/usr/local/etc/oai'
sudo mkdir -m 0777 -p $PREFIX
sudo mkdir -m 0777    $PREFIX/freeDiameter

# freeDiameter configuration file
cp ../etc/mme_fd.sprint.conf  $PREFIX/freeDiameter/mme_fd.conf

cp ../etc/mme.conf  $PREFIX

declare -A MME_CONF

MME_CONF[@MME_S6A_IP_ADDR@]="127.0.0.11"
MME_CONF[@INSTANCE@]=$INSTANCE
MME_CONF[@PREFIX@]=$PREFIX
MME_CONF[@REALM@]='ng4T.com'
MME_CONF[@PID_DIRECTORY@]='/var/run'
MME_CONF[@MME_FQDN@]="mme.${MME_CONF[@REALM@]}"
MME_CONF[@HSS_HOSTNAME@]='hss'
MME_CONF[@HSS_FQDN@]="${MME_CONF[@HSS_HOSTNAME@]}.${MME_CONF[@REALM@]}"
MME_CONF[@HSS_IP_ADDR@]='127.0.0.1'
MME_CONF[@MCC@]='208'
MME_CONF[@MNC@]='93'
MME_CONF[@MME_GID@]='32768'
MME_CONF[@MME_CODE@]='3'
MME_CONF[@TAC_0@]='600'
MME_CONF[@TAC_1@]='601'
MME_CONF[@TAC_2@]='602'
MME_CONF[@MME_INTERFACE_NAME_FOR_S1_MME@]='enp2s0:m1c'
MME_CONF[@MME_IPV4_ADDRESS_FOR_S1_MME@]='192.168.247.102/24'
MME_CONF[@MME_INTERFACE_NAME_FOR_S11@]='enp2s0:m11'
MME_CONF[@MME_IPV4_ADDRESS_FOR_S11@]='172.16.1.102/24'
MME_CONF[@MME_INTERFACE_NAME_FOR_S10@]='enp2s0:m10'
MME_CONF[@MME_IPV4_ADDRESS_FOR_S10@]='192.168.10.110/24'
MME_CONF[@OUTPUT@]='CONSOLE'
MME_CONF[@SGW_IPV4_ADDRESS_FOR_S11_TEST_0@]='172.16.1.104/24'
MME_CONF[@SGW_IPV4_ADDRESS_FOR_S11_0@]='172.16.1.104/24'
MME_CONF[@PEER_MME_IPV4_ADDRESS_FOR_S10_0@]='0.0.0.0/24'
MME_CONF[@PEER_MME_IPV4_ADDRESS_FOR_S10_1@]='0.0.0.0/24'

#implicit MCC MNC 001 01
TAC_SGW_TEST='7'
tmph=`echo "$TAC_SGW_TEST / 256" | bc`
tmpl=`echo "$TAC_SGW_TEST % 256" | bc`
MME_CONF[@TAC-LB_SGW_TEST_0@]=`printf "%02x\n" $tmpl`
MME_CONF[@TAC-HB_SGW_TEST_0@]=`printf "%02x\n" $tmph`

MME_CONF[@MCC_SGW_0@]=${MME_CONF[@MCC@]}
MME_CONF[@MNC3_SGW_0@]=`printf "%03d\n" $(echo ${MME_CONF[@MNC@]} | sed 's/^0*//')`
TAC_SGW_0='600'
tmph=`echo "$TAC_SGW_0 / 256" | bc`
tmpl=`echo "$TAC_SGW_0 % 256" | bc`
MME_CONF[@TAC-LB_SGW_0@]=`printf "%02x\n" $tmpl`
MME_CONF[@TAC-HB_SGW_0@]=`printf "%02x\n" $tmph`

MME_CONF[@MCC_MME_0@]=${MME_CONF[@MCC@]}
MME_CONF[@MNC3_MME_0@]=`printf "%03d\n" $(echo ${MME_CONF[@MNC@]} | sed 's/^0*//')`
TAC_MME_0='601'
tmph=`echo "$TAC_MME_0 / 256" | bc`
tmpl=`echo "$TAC_MME_0 % 256" | bc`
MME_CONF[@TAC-LB_MME_0@]=`printf "%02x\n" $tmpl`
MME_CONF[@TAC-HB_MME_0@]=`printf "%02x\n" $tmph`

MME_CONF[@MCC_MME_1@]=${MME_CONF[@MCC@]}
MME_CONF[@MNC3_MME_1@]=`printf "%03d\n" $(echo ${MME_CONF[@MNC@]} | sed 's/^0*//')`
TAC_MME_1='602'
tmph=`echo "$TAC_MME_1 / 256" | bc`
tmpl=`echo "$TAC_MME_1 % 256" | bc`
MME_CONF[@TAC-LB_MME_1@]=`printf "%02x\n" $tmpl`
MME_CONF[@TAC-HB_MME_1@]=`printf "%02x\n" $tmph`


for K in "${!MME_CONF[@]}"; do 
  egrep -lRZ "$K" $PREFIX | xargs -0 -l sed -i -e "s|$K|${MME_CONF[$K]}|g"
  ret=$?;[[ ret -ne 0 ]] && echo "Tried to replace $K with ${MME_CONF[$K]}"
done

# Generate freeDiameter certificate
sudo ./check_mme_s6a_certificate $PREFIX/freeDiameter mme.${MME_CONF[@REALM@]}

------------------------------------------------------spgwc -------------------------------------------

# prompt has been removed for easier Ctrl+C Ctrl+V
sudo ifconfig enp2s0:sxc 172.55.55.101 up # SPGW-C SXab interface
sudo ifconfig enp2s0:s5c 172.58.58.102 up # SGW-C S5S8 interface
sudo ifconfig enp2s0:p5c 172.58.58.101 up # PGW-C S5S8 interface
sudo ifconfig enp2s0:s11 172.16.1.104 up  # SGW-C S11 interface
INSTANCE=1
PREFIX='/usr/local/etc/oai'
sudo mkdir -m 0777 -p $PREFIX
cp ../../etc/spgw_c.conf  $PREFIX

declare -A SPGWC_CONF

SPGWC_CONF[@INSTANCE@]=$INSTANCE
SPGWC_CONF[@PREFIX@]=$PREFIX
SPGWC_CONF[@PID_DIRECTORY@]='/var/run'
SPGWC_CONF[@SGW_INTERFACE_NAME_FOR_S11@]='enp2s0:s11'
SPGWC_CONF[@SGW_INTERFACE_NAME_FOR_S5_S8_CP@]='enp2s0:s5c'
SPGWC_CONF[@PGW_INTERFACE_NAME_FOR_S5_S8_CP@]='enp2s0:p5c'
SPGWC_CONF[@PGW_INTERFACE_NAME_FOR_SX@]='enp2s0:sxc'
SPGWC_CONF[@DEFAULT_DNS_IPV4_ADDRESS@]='8.8.8.8'
SPGWC_CONF[@DEFAULT_DNS_SEC_IPV4_ADDRESS@]='4.4.4.4'

for K in "${!SPGWC_CONF[@]}"; do 
  egrep -lRZ "$K" $PREFIX | xargs -0 -l sed -i -e "s|$K|${SPGWC_CONF[$K]}|g"
  ret=$?;[[ ret -ne 0 ]] && echo "Tried to replace $K with ${SPGWC_CONF[$K]}"
done

------------------------------------spgw u----------------------------------------------------


# prompt has been removed for easier Ctrl+C Ctrl+V
sudo ifconfig enp2s0:sxu 172.55.55.102 up   # SPGW-U SXab interface
sudo ifconfig enp2s0:s1u 192.168.248.159 up # SPGW-U S1U interface
INSTANCE=1
PREFIX='/usr/local/etc/oai'
sudo mkdir -m 0777 -p $PREFIX
cp ../../etc/spgw_u.conf  $PREFIX

declare -A SPGWU_CONF

SPGWU_CONF[@INSTANCE@]=$INSTANCE
SPGWU_CONF[@PREFIX@]=$PREFIX
SPGWU_CONF[@PID_DIRECTORY@]='/var/run'
SPGWU_CONF[@SGW_INTERFACE_NAME_FOR_S1U_S12_S4_UP@]='enp2s0:s1u'
SPGWU_CONF[@SGW_INTERFACE_NAME_FOR_SX@]='enp2s0:sxu'
SPGWU_CONF[@SGW_INTERFACE_NAME_FOR_SGI@]='enp2s0'

for K in "${!SPGWU_CONF[@]}"; do 
  egrep -lRZ "$K" $PREFIX | xargs -0 -l sed -i -e "s|$K|${SPGWU_CONF[$K]}|g"
  ret=$?;[[ ret -ne 0 ]] && echo "Tried to replace $K with ${SPGWU_CONF[$K]}"
done



------------------------------------? --------------------------------------------
echo '200 lte' | sudo tee --append /etc/iproute2/rt_tables
# Here the gateway is at 192.168.78.245
sudo ip r add default via 192.168.78.245 dev ens10 table lte
# you will have to repeat the following line for each PDN network set in your SPGW-U config file
sudo ip rule add from 12.0.0.0/8 table lte


------------------------------------------------------ifconfig---------------------------------

# MME
sudo ifconfig enp2s0:m11 172.16.1.102 up
sudo ifconfig enp2s0:m1c 192.168.247.102 up

# spgwc
# prompt has been removed for easier Ctrl+C Ctrl+V
sudo ifconfig enp2s0:sxc 172.55.55.101 up # SPGW-C SXab interface
sudo ifconfig enp2s0:s5c 172.58.58.102 up # SGW-C S5S8 interface
sudo ifconfig enp2s0:p5c 172.58.58.101 up # PGW-C S5S8 interface
sudo ifconfig enp2s0:s11 172.16.1.104 up  # SGW-C S11 interface
--------------------------------------------
alias lte="cd /home/kih/Desktop/openairinterface5g/cmake_targets/lte_build_oai/$
c="/home/kih/Desktop/openairinterface5g/targets/PROJECTS/GENERIC-LTE-EPC/CONF/e$
C="-O $c"
Cassandra_Server_IP='127.0.0.1'
PREFIX='/usr/local/etc/oai'

alias scr="sudo spgwc -c $PREFIX/spgw_c.conf"
alias sur="sudo spgwu -c $PREFIX/spgw_u.conf"
alias hssr="hss -j /usr/local/etc/oai/hss_rel14.json"
alias mmer="sudo mme -c $PREFIX/mme.conf"

Cassandra_Server_IP='127.0.0.1'
PREFIX='/usr/local/etc/oai'

alias enbr="/home/kih/Desktop/openairinterface5g/cmake_targets/lte_build_oai/bu$
alias e=enbr
alias udb="oai_hss -j $PREFIX/hss_rel14.json --onlyloadkey"
C2="-O /home/kih/Desktop/enb.conf"



