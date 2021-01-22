#!/bin/bash


function escolher_id
{
    f=$1
    
    cat $f | cut -d: -f1,2
    #Ler id
    while :
    do 
        echo ""
        echo -n "Escolha o id: "
        read id
                    
        #O id é possível?
        isPossible=$(cut -d: -f1 $f | grep $id)
                    
        if [ -z "$isPossible" ]; then
            echo "O id introduzido esta invalido, introduza outro"
        else
            break
        fi
    done
    return $id    
}

#Relatório
#-----------------------------------------------------------

function relatorio_aluno {
	echo -e "\n--Relatório do Aluno--\n"
	echo -n "Introduza o id do aluno: "
	read var
	echo $var

	linha=`awk -F ":" '{if ($1 == '$var') print $0;}' ./BD/Aluno.txt`
	
	IFS=":" read -r idAluno nome idUniDest idUniOrig idRespDest idRespOrig <<< "$linha"

	linha2=`grep $idUniDest ./BD/UniDest.txt`
	IFS=":" read -r var1 nomeUniDestino<<< "$linha2"

	linha3=`grep $idUniOrig ./BD/UniOrig.txt`
	IFS=":" read -r var2 nomeUniOrigem <<< "$linha3"

	linha4=`awk -F ":" '{if ($1 == '$idRespDest') print $0;}' ./BD/RespDest.txt`
	IFS=":" read -r var3 nomeRespDestino var4 <<< "$linha4"

	linha5=`awk -F ":" '{if ($1 == '$idRespOrig') print $0;}' ./BD/RespOrig.txt`
	IFS=":" read -r var3 nomeRespOrigem var5 <<< "$linha5"

	echo "O aluno ${nome} com o id ${idAluno}"
	echo "vai para a ${nomeUniDestino} vindo da ${nomeUniOrigem}."
	echo "O responsavel de origem é o ${nomeRespOrigem} e o responsavel de destino é o ${nomeRespDestino}."
     
}

function relatorio_disciplinascomalunos {
	echo -e "\n--Relatório da Disciplina--\n"
	echo -n "Introduza o id da Disciplina: "
	read var
	linha5=`awk -F ":" '{if ($1 == '$var') print $0;}' ./BD/Disciplina.txt`
	IFS=":" read -r idDisciplina nome var2 var3 idRespDest var4 <<< "$linha5"

	echo "A disciplina de ${nome} tem os seguintes alunos"
	awk -F ":" '{if ($5 == '$idRespDest') print $2;}' ./BD/Aluno.txt
	
	
}
    
function relatorio_universidade {
    echo -e "\n--Relatório da Universidade--\n"
	echo -n "Introduza o id da Universidade de Origem: "
	read var
	echo ""
	echo "A universidade de origem tem os seguintes alunos:"		
	awk -F ":" '{if ($4 == '$var') print $2;}' ./BD/Aluno.txt
	
	echo -n "Introduza o id da Universidade de Destino: "
	read var
	echo ""
	echo "A universidade de destino tem os seguintes alunos:"		
	awk -F ":" '{if ($3 == '$var') print $2;}' ./BD/Aluno.txt
	
}

function relatorio_disciplina {
    echo -e "\n--Relatório da Disciplina--\n"
	echo -n "Introduza o id da disciplina: "	
	read var
	linha=`awk -F ":" '{if ($1 == '$var') print $0;}' ./BD/Disciplina.txt`
	IFS=":" read -r idDisciplina nome ano semestre idRespDest idUniDest <<< "$linha"
	
	linha1=`awk -F ":" '{if ($1 == '$idRespDest') print $0;}' ./BD/RespDest.txt`
	IFS=":" read -r var3 nomeRespDestino idUniDest <<< "$linha1"

	linha2=`grep $idUniDest ./BD/UniDest.txt`
	IFS=":" read -r var1 nomeUniDestino<<< "$linha2"

	
	
	
	echo 'A disciplina denominada' $nome 'e do ano ' $ano 'e é lecionada no' $semestre 'semestre, na Universidade' $nomeUnidDestino 'e o responsavel é o professor' $nomeRespDestino
}

#-----------------------------------------------------------


#Apagar
#-----------------------------------------------------------

function apagar_universidade 
{
    fUniOrig="./BD/UniOrig.txt"
    fUniDest="./BD/UniDest.txt"

    while :
    do 
        echo -e "\n--Apagar Universidade--\n"
        echo -e "\t1 - Origem"
        echo -e "\t2 - Destino"
        echo -n "Introduza a opção: "
        read aux

        case $aux in 
            "1")
                echo -e "\nLista de Universidades de Origem:\n" 
                escolher_id $fUniOrig 
                idUniOrig=$?

                grep -v "^${idUniOrig}" $fUniOrig > "teste.txt"
                mv "teste.txt" $fUniOrig

                return
                ;;
            "2")

                echo -e "\nLista de Universidade de Destino:\n"
                escolher_id $fUniDest 
                idUniDest=$?

                grep -v "^${idUniDest}" $fUniDest > "teste.txt"
                mv "teste.txt" $fUniDest

                return
                ;;
            *)

                echo -e "\ntOpção inválida!\n"
        esac         
    done
}

function apagar_professor
{
    fRespOrig="./BD/RespOrig.txt"
    fRespDest="./BD/RespDest.txt"
    fAluno="./BD/Aluno.txt"
    while :
    do 
        echo -e "\n--Apagar Professor--\n"
        echo -e "\t1 - Origem"
        echo -e "\t2 - Destino"
        echo -n "Introduza a opção: "
        read aux

        case $aux in 
            "1")
                echo -e "\nLista de professores de Origem:\n"
                escolher_id $fRespOrig 
                idRespOrig=$?

                grep -v "^${idRespOrig}" $fRespOrig > "teste.txt"
                mv "teste.txt" $fRespOrig
                return
                ;;

            "2")
                echo -e "\nLista de professores de Destino:\n"
                escolher_id $fRespDest 
                idRespDest=$?
                
                grep -v "^${idRespDest}" $fRespDest > "teste.txt"
                mv "teste.txt" $fRespDest
                return
                ;;
            *)

                echo -e "\ntOpção inválida!\n"
        esac         
    done
}

function apagar_aluno
{
    fAluno="./BD/Aluno.txt"
    fInscrito="./BD/Inscrito.txt"
    echo -e "\n--Apagar Aluno--\n"
    echo -e "\nLista de Alunos:\n"
    escolher_id $fAluno
    idAluno=$?

    grep -v "^${idAluno}" $fAluno > "teste.txt"
    mv "teste.txt" $fAluno

    grep -v "^${idAluno}" $fInscrito > "teste.txt"
    mv "teste.txt" $fInscrito
}

function apagar_disciplina
{
    fDisciplina="./BD/Disciplina.txt"
    fInscrito="./BD/Inscrito.txt"

    echo -e "\n--Apagar Disciplina--\n"
    echo -e "\nLista de Disciplinas:\n"
    escolher_id $fDisciplina
    idDisciplina=$?

    grep -v "^${idDisciplina}" $fDisciplina > "teste.txt"
    mv "teste.txt" $fDisciplina

    grep -v "${idDisciplina}$" $fInscrito > "teste.txt"
    mv "teste.txt" $fInscrito
}

#-----------------------------------------------------------


#Editar
#-----------------------------------------------------------

function visualizar_universidades
{
    fUniOrig="./BD/UniOrig.txt"
    fUniDest="./BD/UniDest.txt"

    while :
    do 
        echo -e "\n--Visualizar Universidades--\n"
        echo -e "\t1 - Origem"
        echo -e "\t2 - Destino"
        echo -n "Introduza a opção: "
        read aux

        case $aux in 
            "1")
                echo -e "\nLista de Universidades de Origem:\n" 
                cat $fUniOrig
                return
                ;;
            "2")
                echo -e "\nLista de Universidades de Destino:\n" 
                cat $fUniDest
                return
                ;;
            *)
                echo -e "\ntOpção inválida!\n"
        esac         
    done
}

function visualizar_professores
{
    fRespOrig="./BD/RespOrig.txt"
    fRespDest="./BD/RespDest.txt"

    while :
    do 
        echo -e "\n--Visualizar Professores--\n"
        echo -e "\t1 - Origem"
        echo -e "\t2 - Destino"
        echo -n "Introduza a opção: "
        read aux

        case $aux in 
            "1")
                echo -e "\nLista de Professores de Origem:\n" 
                #cat $fRespOrig
                
                lista_de_ids=$(cut -d: -f1 ${fRespOrig})

                
                for i in $lista_de_ids
                do
                    linha=$(grep ^$i ${fRespOrig})
                    echo $linha
                    IFS=":" read -r idRespOrig nomeRespOrig idUniOrig<<< "$linha"
                    echo "$idUniOrig"

                    grep $idUniOrig $fUniOrig

                    echo "$idRespOrig:$nomeRespOrig:$nomeUniOrig"

                done
                return
                ;;
            "2")
                echo -e "\nLista de Professores de Destino:\n" 
                cat $fRespDest
                return
                ;;
            *)
                echo -e "\ntOpção inválida!\n"
        esac         
    done
}

function visualizar_alunos
{
    fAluno="./BD/Aluno.txt"

    echo -e "\n--Visualizar Alunos--\n"
    echo -e "\nLista de Alunos:\n" 
    cat $fAluno
}

function visualizar_disciplinas
{
    fDisciplina="./BD/Disciplina.txt"

    echo -e "\n--Visualizar Disciplinas--\n"
    echo -e "\nLista Disciplinas:\n" 
    cat $fDisciplina
}

function visualizar_inscricao
{
    fInscrito="./BD/Inscrito.txt"
    fAluno="./BD/Aluno.txt"
    
    echo -e "\n--Visualizar Inscrições--\n"
    echo -e "\nLista de Alunos:\n" 
    escolher_id $fAluno 
    idAluno=$?

    #Disciplinas em que esse aluno está inscrito
    echo -e "\nLista de disciplinas inscritas (id ALuno:id Disciplina)"                
    grep "^${idAluno}" $fInscrito
}

#-----------------------------------------------------------
1

#Editar
#-----------------------------------------------------------

function editar_universidade 
{
    fUniOrig="./BD/UniOrig.txt"
    fUniDest="./BD/UniDest.txt"

    while :
    do 
        echo -e "\n--Editar Universidade--\n"
        echo -e "\t1 - Origem"
        echo -e "\t2 - Destino"
        echo -n "Introduza a opção: "
        read aux

        case $aux in 
            "1")
                echo -e "\nLista de Universidades de Origem:\n" 
                escolher_id $fUniOrig 
                idUniOrig=$?

                #Modificar
                echo -n "Introduza o novo nome da universidade: "
                read novoNome
                
                grep -v "^${idUniOrig}" $fUniOrig > "teste.txt"
                mv "teste.txt" $fUniOrig

                echo "${idUniOrig}:${novoNome}" >> $fUniOrig

                sort -n $fUniOrig > "tmp.txt"
                mv "tmp.txt" $fUniOrig
                return
                ;;
            "2")

                echo -e "\nLista de Universidades de Destino:\n"
                escolher_id $fUniDest 
                idUniDest=$?

                #Modificar
                echo -n "Introduza o novo nome da universidade: "
                read novoNome
                
                grep -v "^${idUniDest}" $fUniDest > "teste.txt"
                mv "teste.txt" $fUniDest

                echo "${idUniDest}:${novoNome}" >> $fUniDest

                sort -n $fUniDest > "tmp.txt"
                mv "tmp.txt" $fUniDest
                return
                ;;
            *)

                echo -e "\nOpção inválida!\n"
        esac         
    done
}

function editar_professor
{
    fRespOrig="./BD/RespOrig.txt"
    fRespDest="./BD/RespDest.txt"

    fUniOrig="./BD/UniOrig.txt"
    fUniDest="./BD/UniDest.txt"

    while :
    do 
        echo -e "\n--Editar Professor--\n"
        echo -e "\t1 - Origem"
        echo -e "\t2 - Destino"
        echo -n "Introduza a opção: "
        read aux

        case $aux in 
            "1")
                echo -e "\nLista de professores de Origem:\n"
                escolher_id $fRespOrig 
                idRespOrig=$?


                #Modificar
                echo -n "Introduza o novo nome do professor: "
                read novoNome
                
                echo -e "\nEscolha a nova universidade do professor:\n"
                escolher_id $fUniOrig 
                idUniOrig=$?

                grep -v "^${idRespOrig}" $fRespOrig > "teste.txt"
                mv "teste.txt" $fRespOrig

                echo "${idRespOrig}:${novoNome}:${idUniOrig}" >> $fRespOrig

                sort -n $fRespOrig > "tmp.txt"
                mv "tmp.txt" $fRespOrig
                return
                ;;

            "2")
                echo -e "\nLista de professores de Destino:\n"
                escolher_id $fRespDest 
                idRespDest=$?

                #Modificar
                echo -n "Introduza o novo nome do professor: "
                read novoNome
                
                echo -e "\nEscolha a nova universidade do professor:\n"
                escolher_id $fUniDest 
                idUniDest=$?
                
                grep -v "^${idRespDest}" $fRespDest > "teste.txt"
                mv "teste.txt" $fRespDest

                echo "${idRespDest}:${novoNome}:${idUniDest}" >> $fRespDest

                sort -n $fRespDest > "tmp.txt"
                mv "tmp.txt" $fRespDest
                return
                ;;
            *)

                echo -e "\nOpção inválida!\n"
        esac         
    done
}

function editar_aluno
{
    fAluno="./BD/Aluno.txt"

    fUniDest="./BD/UniDest.txt"
    fUniOrig="./BD/UniOrig.txt"

    fRespDest="./BD/RespDest.txt"
    fRespOrig="./BD/RespOrig.txt"

    echo -e "\n--Editar Aluno--\n"
    echo -e "\nLista de Alunos:\n"
    escolher_id $fAluno
    idAluno=$?

    echo -n "Introduza o novo nome do aluno: "
    read novoNome

    echo -e "\nEscolha a nova universidade de destino:\n"
    escolher_id $fUniDest 
    idUniDest=$?

    echo -e "\nEscolha a nova universidade de origem:\n"
    escolher_id $fUniOrig 
    idUniOrig=$?
        
    echo -e "\nEscolha o novo responsavel de destino:\n"
    escolher_id $fRespDest
    idRespDest=$?

    echo -e "\nEscolha o novo responsavel de origem:\n"
    escolher_id $fRespOrig
    idRespOrig=$?

    grep -v "^${idAluno}" $fAluno > "teste.txt"
    mv "teste.txt" $fAluno

    #Aluno(**idAluno**, nome, idUniDest, idUniOrig, idRespDest, idRespOrig)
    echo "${idAluno}:${novoNome}:${idUniDest}:${idUniOrig}:${idRespDest}:${idRespOrig}" >> $fAluno

    sort -n $fAluno > "tmp.txt"
    mv "tmp.txt" $fAluno
}

function editar_disciplina
{
    fDisciplina="./BD/Disciplina.txt"
    fUniDest="./BD/UniDest.txt"
    fRespDest="./BD/RespDest.txt"

    echo -e "\n--Editar Disciplina--\n"
    echo -e "\nLista de Disciplinas:\n"
    escolher_id $fDisciplina
    idDisciplina=$?

    echo -n "Introduza o novo nome da disciplina: "
    read novoNome

    while :
    do
        echo -n "Escolha o novo ano da disciplina(1, 2 ou 3): "
        read novoAno

        if [ "$novoAno" = "1" ] || [ "$novoAno" = "2" ] || [ "$novoAno" = "3" ]
        then
            break
        else 
            echo -e "\nOpção inválida, o ano precisa de ser 1, 2 ou 3!\n"
        fi
    done
    
    while :
    do
        echo -n "Escolha o novo semestre da disciplina(1 ou 2): "
        read novoSemestre

        if [ "$novoSemestre" = "1" ] || [ "$novoSemestre" = "2" ]
        then
            break
        else 
            echo -e "\nOpção inválida, o semestre precisa de ser 1 ou 2!\n"
        fi
    done

    echo -e "\nEscolha o novo responsavel pela disciplina:\n"
    escolher_id $fRespDest
    idRespDest=$?

    echo -e "\nEscolha a nova universidade da disciplina:\n"
    escolher_id $fUniDest
    idUniDest=$?

    grep -v "^${idDisciplina}" $fDisciplina > "teste.txt"
    mv "teste.txt" $fDisciplina

    #Disciplina(**idDisciplina**, nome, ano, semestre, idRespDest, idUniDest)
    echo "${idDisciplina}:${novoNome}:${novoAno}:${novoSemestre}:${idRespDest}:${idUniDest}" >> $fDisciplina

    sort -n $fDisciplina > "tmp.txt"

    mv "tmp.txt" $fDisciplina
}

function editar_inscricao
{
    fInscrito="./BD/Inscrito.txt"
    fAluno="./BD/Aluno.txt"
    fDisciplina="./BD/Disciplina.txt"

    while :
    do 
        echo -e "\n--Editar Inscricao--\n"
        echo -e "\t1 - Remover disciplina"
        echo -e "\t2 - Adicionar disciplina"
        echo -n "Introduza a opção: "
        read aux

        case $aux in 
            "1")
                echo -e "\nLista de Alunos:\n" 
                escolher_id $fAluno 
                idAluno=$?

                
                echo -e "\nLista de disciplinas inscritas"
                echo -e "Escolhe o id da disciplina que pretende desinscrever: \n"
                escolher_id $fDisciplina
                idDisciplina=$?

                grep -v "^${idAluno}:${idDisciplina}" $fInscrito > "teste.txt"
                mv "teste.txt" $fInscrito

                return
                ;;
            "2")
                echo -e "\nLista de Alunos:\n" 
                escolher_id $fAluno 
                idAluno=$?

                echo -e "\nLista de disciplinas:\n"
                echo -e "Escolhe o id da disciplina que pretende inscrever: \n"
                escolher_id $fDisciplina
                idDisciplina=$?

                if [ $(grep "^${idAluno}:${idDisciplina}" $fInscrito) ]
                then
                    echo "O aluno já está inscrito nessa disciplina"
                else
                    echo "${idAluno}:${idDisciplina}" >> $fInscrito
                    sort -n $fInscrito > "tmp.txt"
                    mv "tmp.txt" $fInscrito
                fi
                return
                ;;
            *)

                echo -e "\nOpção inválida!\n"
        esac         
    done
}

#-----------------------------------------------------------


#Registo
#-----------------------------------------------------------

function new_id {
    maxid=$(tail -n 1 $1 | cut -d ':' -f 1)
    let maxid=$maxid+1
    return $maxid
}

function registar_universidade {
    fUniOrig="./BD/UniOrig.txt"
    fUniDest="./BD/UniDest.txt"

    while :
    do
        echo -e "\n--Registar Universidade--\n"
        echo -e "\t1 - Origem"
        echo -e "\t2 - Destino"
        echo -n "Introduza a opção: "
        read opUni
        
        case $opUni in
        "1")
            new_id $fUniOrig
            maxid=$?
            
            echo -n "Introduza o nome da Universidade: "
            while :
            do 
                read nomeUni                 

                #O nome já existe?
                isPossible=$(cut -d: -f2 $fUniOrig | grep $nomeUni)
                
                if [ -z "$isPossible" ]; then
                    echo "$maxid:$nomeUni" >> $fUniOrig
                    return
                else
                    echo -n "O nome da Universidade já existe! Introduza outro: "
                fi
            done
            ;;    
        "2")
            new_id $fUniDest
            maxid=$?
            
            echo -n "Introduza o nome da Universidade: "
            while :
            do 
                read nomeUniDest     

                #O nome já existe?
                isPossible=$( cut -d: -f2 $fUniDest | grep $nomeUniDest)
                                
                if [ -z "$isPossible" ]; then
                    echo "$maxid:$nomeUniDest" >> $fUniDest
                    return
                else
                    echo -n "O nome da Universidade já existe! Introduza outro:"
                fi
            done
            ;;
        *)
            echo -e "\n\tOpção inválida!\n"
            ;;
        esac
    done
}

function registar_professor {
    fUniOrig="./BD/UniOrig.txt"
    fUniDest="./BD/UniDest.txt"

    fRespOrig="./BD/RespOrig.txt"
    fRespDest="./BD/RespDest.txt"
    echo -e "\n--Registar Professor--\n"
    while :
    do
        echo -e "Escolha o local de onde é o Professor: \n"
        echo -e "\t1 - Origem"
        echo -e "\t2 - Destino"
        echo -n "Introduza a opção: "
        read opProf
        
        case $opProf in
            "1")
                new_id $fRespOrig
                maxid=$?
            
                echo -n "Introduza o nome do Professor: "
                read nomeProf
            
                cat $fUniOrig | cut -d: -f1,2
                while :
                do 
                    echo -en "\nEscolha o id da Universidade do Professor: "
                    read idUniOrig           

                    #O id é possível?
                    isPossible=$( cut -d: -f1 $fUniOrig | grep $idUniOrig)

                    if [ -z "$isPossible" ]; then
                        echo "O id introduzido está invalido, introduza outro!"
                    else
                        echo "$maxid:$nomeProf:$idUniOrig" >> $fRespOrig
                        return
                    fi

                done
                ;;    
            "2")
                new_id $fRespDest
                maxid=$?
            
                echo -n "Introduza o nome do Professor: "
                read nomeProf
            
                cat $fUniDest | cut -d: -f1,2
                while :
                do 
                    echo -en "\nEscolha o id da Universidade do Professor: "
                    read idUniDest   

                    #O id é possível?
                    isPossible=$(cut -d: -f1 $fUniDest | grep $idUniDest)

                    if [ -z "$isPossible" ]; then
                        echo "O id introduzido está inválido, introduza outro!"
                    else
                        echo "$maxid:$nomeProf:$idUniDest" >> $fRespDest
                        return
                    fi
                done
                ;;
            *)
                echo -e "\n\tOpção inválida!\n" ;;
        esac
    done
}

function registar_disciplina {

    fDisciplina="./BD/Disciplina.txt"
    fUniDest="./BD/UniDest.txt"
    fRespDest="./BD/RespDest.txt"

    echo -e "\n--Registar Disciplina--\n"
    
    #nome
    echo -n "Introduza o nome: "
    read nomeDisciplina
    
    #ano
    echo "Escolha entre as opções o ano: "
    while :
    do
        echo -e "\t1 - 1º Ano"
        echo -e "\t2 - 2º Ano"
        echo -e "\t3 - 3º Ano"
        echo -n "Inserido: "
        read opAno
        
        case $opAno in
        "1")
            ano=$opAno 
            break ;;
        "2")
            ano=$opAno
            break ;;
        "3")
            ano=$opAno
            break ;;
        *)
            echo -e "\n\tOpção inválida!\n" ;;
        esac
    done
    
    #semestre
    echo "Escolha entre as opções o semestre: "
    while :
    do
        echo -e "\t1 - 1º Semestre"
        echo -e "\t2 - 2º Semestre"
        echo -n "Inserido: "
        read opSemestre
        
        case $opSemestre in
        "1")
            semestre=$opSemestre
            break ;;
        "2")
            semestre=$opSemestre 
            break ;;
        *)
            echo -e "\n\tOpção inválida!\n" ;;
        esac
    done
    
    #idUniDest
    echo -e "\nEscolha a universidade da disciplina: "
    cat $fUniDest | cut -d: -f1,2
    while :
    do 
        echo -en "\nEscolha o id: "
        read idUniDest
                        
        #O id é possível?
        isPossible=$(cut -d: -f1 $fUniDest | grep $idUniDest)
                        
        if [ -z "$isPossible" ]; then
            echo "O id introduzido está inválido, introduza outro!"
        else
            break
        fi
    done

    #idRespDest
    echo "Lista de Professor possíveis: "
    grep "${idUniDest}$" $fRespDest | cut -d: -f1,2 
    
    while :
    do 
        echo -en "\nEscolha o id do responsavel pela disciplina: "
        read idRespDest         
        
        isPossible=$( cut -d: -f1 $fRespDest | grep $idRespDest)

        if [ -z "$isPossible" ]; then
            echo "O id introduzido está inválido, introduza outro!"
        else
            break
    fi
    done
    
    new_id $fDisciplina
    maxid=$?
    
    echo "$maxid:$nomeDisciplina:$ano:$semestre:$idRespDest:$idUniDest" >> $fDisciplina
}

function registar_aluno {
    fAluno="./BD/Aluno.txt"
    fUniDest="./BD/UniDest.txt"
    fUniOrig="./BD/UniOrig.txt"
    fRespOrig="./BD/RespOrig.txt"
    fRespDest="./BD/RespDest.txt"
    
    new_id $fAluno
    maxid=$?
    
    echo -e "\n--Registar Aluno--\n"
    echo -n "Introduza o nome do aluno: "
    read nomeAluno
    
    echo "Lista de universidades de destino: "
    cat $fUniDest | cut -d: -f1,2
    while :
    do
        echo -n "Introduza o id da Universidade de Destino do aluno: " 
        read idUniDest           

        #O id já existe?
        isPossible=$( cut -d: -f1 $fUniDest | grep $idUniDest)
        
        if [ -z "$isPossible" ]; then
            echo "O id da Universidade não existe! Introduza outro:"
        else
            break
        fi
    done
      
    echo "Lista de universidades de destino: "
    cat $fUniOrig | cut -d: -f1,2
    while :
    do
      
        echo -n "Introduza o id da Universidade de Origem: " 
        read idUniOrig                 
        #O id já existe?
        isPossible=$( cut -d: -f1 $fUniOrig | grep $idUniOrig)
                        
        if [ -z "$isPossible" ]; then
            echo "O id da Universidade não existe! Introduza outro:"
        else
            break
        fi
    done
    
    #idRespDest
    echo "Lista de Professor de Destino possíveis: "
    grep "${idUniDest}$" $fRespDest | cut -d: -f1,2 
    
    while :
    do 
        echo -en "\nEscolha o id do responsavel de destino: "
        read idRespDest         
        
        isPossible=$( cut -d: -f1 $fRespDest | grep $idRespDest)

        if [ -z "$isPossible" ]; then
            echo "O id introduzido está inválido, introduza outro!"
        else
            break
    fi
    done
    
    #idRespOrig
    echo "Lista de Professor de Origem possíveis: "
    grep "${idUniOrig}$" $fRespOrig | cut -d: -f1,2 
    
    while :
    do 
        echo -en "\nEscolha o id do responsavel de origem: "
        read idRespOrig
        
        isPossible=$( cut -d: -f1 $fRespOrig | grep $idRespOrig)

        if [ -z "$isPossible" ]; then
            echo "O id introduzido está inválido, introduza outro!"
        else
            break
    fi
    done

    echo "$maxid:$nomeAluno:$idUniDest:$idUniOrig:$idRespDest:$idRespOrig" >> $fAluno
}

#-------------------------------------------------------------------------------------

function menu_principal
{
    echo -e "\n---Menu Principal---\n"
    echo -e "\t1 - Registar Dados"
    echo -e "\t2 - Alterar Dados"
    echo -e "\t3 - Visualizar Dados"
    echo -e "\t4 - Relatórios dos Dados"
    echo -e "\t5 - Apagar Dados"
    echo -e "\t6 - Gestão do(s) ficheiro(s) de Base de Dados\n"
    echo -e "\t0 - Sair do programa\n"
    echo -n "Introduza a opção: "
    read aux
    return $aux
}

function menu_registar
{
    echo -e "\n--Registo--\n"
    echo -e "\t1 - Universidade"
    echo -e "\t2 - Professor"
    echo -e "\t3 - Aluno"
    echo -e "\t4 - Disciplina\n"
    echo -e "\t0 - Menu Principal"
    echo -n "Introduza a opção: "
    read aux
    return $aux
}

function menu_editar
{
    echo -e "\n--Edição--\n"
    echo -e "\t1 - Universidade"
    echo -e "\t2 - Professor"
    echo -e "\t3 - Aluno"
    echo -e "\t4 - Disciplina"
    echo -e "\t5 - Inscrição\n"
    echo -e "\t0 - Menu Principal"
    echo -n "Introduza a opção: "
    read aux
    return $aux
}

function menu_visualizar
{
    echo -e "\n--Visualizar Dados--\n"
    echo -e "\t1 - Universidades"
    echo -e "\t2 - Professores"
    echo -e "\t3 - Alunos"
    echo -e "\t4 - Disciplinas"
    echo -e "\t5 - Inscrições\n"
    echo -e "\t0 - Menu Principal"
    echo -n "Introduza a opção: "
    read aux
    return $aux
}

function menu_relatorios
{
    echo -e "\n--Relatórios--\n"
    echo -e "\t1 - Aluno"
    echo -e "\t2 - Alunos na Disciplina"
    echo -e "\t3 - Universidade"
    echo -e "\t4 - Disciplina\n"
    echo -e "\t0 - Menu Principal"
    echo -n "Introduza a opção: "
    read aux
    return $aux 
}


function menu_apagar
{
    echo -e "\n--Apagar Dados--\n"
    echo -e "\t1 - Universidades"
    echo -e "\t2 - Professores"
    echo -e "\t3 - Alunos"
    echo -e "\t4 - Disciplinas\n"
    echo -e "\t0 - Menu Principal"
    echo -n "Introduza a opção: "
    read aux
    return $aux
}

function menu_gestao
{
    echo -e "\n--Gestão de Base de Dados--\n"
    echo -e "\t1 - (Backup) Criar uma cópia de segurança"
    echo -e "\t0 - Menu Principal"
    echo -n "Introduza a opção: "
    read aux
    return $aux
}

function registar
{
    while :
    do
        menu_registar
        inserido=$?
            
        case $inserido in
        
            "1")
                registar_universidade
                ;;
            "2")
                registar_professor
                ;;
            "3")
                registar_aluno
                ;;
            "4")  
                registar_disciplina
                ;;
            "0")
                break
                ;;
            *)
                echo -e "\n\tOpção inválida!\n"
                ;;
        esac
    done
}

function editar
{
    while :
    do
        menu_editar
        inserido=$?
            
        case $inserido in
        
            "1")
                editar_universidade                
                ;;
            "2")
                editar_professor
                ;;
            "3")
                editar_aluno
                ;;
            "4")
                editar_disciplina
                ;;
            "5")
                editar_inscricao
                ;;
            "0")
            
                break
                ;;
            *)
            
                echo -e "\n\tOpção inválida!\n"
                ;;
        esac
    done
}

function visualizar
{
    while :
    do
        menu_visualizar
        inserido=$?
            
        case $inserido in

            "1")
                visualizar_universidades
                ;;
            "2")
                visualizar_professores
                ;;
            "3")
                visualizar_alunos
                ;;
            "4")
                visualizar_disciplinas
                ;;
            "5")
                visualizar_inscricao
                ;;
            "0")
                
                break
                ;;
            *)
                
                echo -e "\n\tOpção inválida!\n"
                ;;
        esac
    done
}

function relatorios
{
    while :
    do
        menu_relatorios
        inserido=$?
        
        case $inserido in
            
            "1")
                relatorio_aluno
                ;;
            "2")
                relatorio_disciplinascomalunos
                ;;
            "3")
                relatorio_universidade
                ;;
            "4")
                relatorio_disciplina
                ;;
            "0")
            
                break
                ;;
            *)
                
                echo -e "\n\tOpção inválida!\n"
                ;;
        esac
    done
}

function apagar
{
    while :
    do
        menu_apagar
        inserido=$?
            
        case $inserido in

            "1")
                apagar_universidade
                ;;
            "2")
                apagar_professor
                ;;
            "3")
                apagar_aluno
                ;;
            "4")
                apagar_disciplina
                ;;
            "0")
                break
                ;;
            *)
                
                echo -e "\n\tOpção inválida!\n"
                ;;
        esac
    done
}

function gestao
{
    while :
    do
        menu_gestao
        inserido=$?
        
        case $inserido in

            "1")
                SRCDIR="BD/"
                DESTDIR="./Backup/"
                FILENAME="Backup_$(date +%d-%b-%y)_$(date +%-T).tgz" 
                tar --create --gzip --file=$DESTDIR$FILENAME $SRCDIR

                ;;  
            "0")

                break
                ;;
            *)
                
                echo -e "\n\tOpção inválida!\n"
                ;;
        esac
    done
}

function main
{
    while :
    do
        menu_principal
        inserido=$?

        case $inserido in

            "1")
            
                registar
                ;;
            "2")
                
                editar
                ;;
            "3")
                
                visualizar 
                ;;
            "4")
                
                relatorios
                ;;

            "5")
                apagar
                ;;
            "6")
                
                gestao
                ;;
            "0")
            
                exit 0
                ;;
            *)
                
                echo -e "\n\tOpção inválida!\n"
                ;;
        esac
    done
}

#Inicio do programa
main
