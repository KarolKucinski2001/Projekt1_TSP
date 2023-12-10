import Random
# import Distribution
using Pkg
import XLSX
# using Distributions
function generateRadomSolution(tsp)
    
    IndexOfCities = collect(1:length(tsp))
    solution = []
    for i in 1:length(tsp)
        randomCity = IndexOfCities[Random.rand(1:length(IndexOfCities))]
        push!(solution,randomCity)
        deleteat!(IndexOfCities, findall(x->x==randomCity,IndexOfCities))    
    end
    print("----\n")
    print(length(solution))
    print("----\n")
    print(solution)
    return hcat(solution)
end

#print(solution)
function CalculateLengthRoute(tsp, solution)
    totalRoadLength = 0
    for i in 1:length(solution)-1 
        totalRoadLength += tsp[solution[i]][solution[i+1]]
    end
    i = length(solution)-1
    totalRoadLength +=tsp[solution[1]][solution[i+1]]  
   
    return totalRoadLength
end

#SWAP
function generateNeighbours(solution)
    neighbours = []
    for i in 1:length(solution)
        for j in range(i + 1, length(solution))
            neighbour = copy(solution)
            neighbour[i] = solution[j]
            neighbour[j] = solution[i]
            push!(neighbours,neighbour)
        end
    end
    return neighbours
end
#insert, inverse dodac


function getBestNeighbour(tsp, neighbours)
    besttotalRoadLength = CalculateLengthRoute(tsp, neighbours[1])
    bestNeighbour = neighbours[1]
    for neighbour in neighbours
        currenttotalRoadLength = CalculateLengthRoute(tsp, neighbour)
        if currenttotalRoadLength < besttotalRoadLength
            besttotalRoadLength = currenttotalRoadLength
            bestNeighbour = neighbour
        end    
    end
    return bestNeighbour, besttotalRoadLength
end    
# include("./hillClimbing.jl")
# using .hillClimbing


print("sss")
function get_data(xlsx_file_list)
    Pkg.add("XLSX")
    n = length(xlsx_file_list)
    objects = Vector(undef,n)
    sheets = Vector(undef,n)
    datas = Vector(undef,n)
    for i in eachindex(xlsx_file_list)
        objects[i] = XLSX.readxlsx(xlsx_file_list[i])
        sheets[i] = objects[i][XLSX.sheetnames(objects[i])[1]]
        datas[i] = sheets[i][:]
    end
    return datas    
end

EXCEL_F_NAME_1 = "TSP_29.xlsx"          # 29 cities    
EXCEL_F_NAME_2 = "Dane_TSP_48.xlsx"     # 48 cities
EXCEL_F_NAME_3 = "Dane_TSP_76.xlsx"     # 76 cities
EXCEL_F_NAME_4 = "Dane_TSP_127.xlsx"    # 127 cities

FILES = [EXCEL_F_NAME_1,EXCEL_F_NAME_2,EXCEL_F_NAME_3,EXCEL_F_NAME_4]

all = get_data(FILES)


# data_1 = all[1]
# print(size(data_1))
# println(data_1[:,1])
# data_1 = data_1[2:size(data_1)[1],2:size(data_1)[2]]
# print(data_1[:,1]) # printuje wszystkie wiersze i pierwsza kolumne
# print("-------------\n")
# tsp = [
#     [0, 400, 500, 300],
#     [400, 0, 300, 500],
#     [500, 300, 0, 400],
#     [300, 500, 400, 0]
# ]
# print(tsp)
# print(generateRadomSolution(tsp))
#tsp = Copy(data_1)

function dataToArrayOfArrays(data_1)
    tsp = copy(data_1)
    tab=[]
 
    for i in 1:isqrt(length(tsp))

        push!(tab,hcat(data_1[:,i]))
    end       
    #print(tab) 
    print(length(tab))
    tsp = copy(tab)
    return tsp
end
#tsp = dataToArrayOfArrays(data_1)

print("\n-------------")
function CalculateLengthRoute(tsp, solution)
    totalRoadLength = 0
    for i in 1:length(solution)-1 
        totalRoadLength += tsp[solution[i]][solution[i+1]]
    end
    i = length(solution)-1
    totalRoadLength +=tsp[solution[1]][solution[i+1]]  
   
    return totalRoadLength
end



function generateNeighbours(solution, n)
    neighbours = []
    for i in 1:n
        for j in range(i + 1, n)
            neighbour = copy(solution)
            neighbour[i] = solution[j]
            neighbour[j] = solution[i]
            push!(neighbours,neighbour)
        end
    end
    return neighbours
end
 

function simulatedAnnealing(tsp, alfa, staringTemp, finishingTemp, iterationTemp, n )
    currentTemperature = staringTemp
    currentSolution = generateRadomSolution(tsp)

    # # can add more termination criteria
    while(currentTemperature>=finishingTemp)  
        for i in 1:iterationTemp
            neighbors = generateNeighbours(currentSolution,25)
            #print(neighbors)
            #print(length(neighbors))
            x = rand(1:length(neighbors))
            newSolution = neighbors[x]
            currRoute = CalculateLengthRoute(tsp,newSolution) - CalculateLengthRoute(tsp,currentSolution)
            asaa4=rand(.0:.0001:1.0)
            csa= exp(-currRoute / currentTemperature)

            if(currRoute<0)
                currentSolution = newSolution
            else
            if(rand(.0:.0001:1.0)< exp(-currRoute / currentTemperature))
                        currentSolution = newSolution
            end
                
                
            end
            currentTemperature *=alfa 
             
        
        end
    end
    print(currentSolution)
    print(CalculateLengthRoute(tsp,currentSolution))
    return currentSolution, CalculateLengthRoute(tsp,currentSolution)
end


data_1 = all[2]
data_1 = data_1[2:size(data_1)[1],2:size(data_1)[2]]
#tsp =Copy(data_1)
tsp = dataToArrayOfArrays(data_1)
#tsp, alfa,  staringTemp, finishingTemp, iterationTemp )
print("Excel pierwszy")
print("\nExcel pierwszy, alfa=0.99, starting temp = 100, finishin temp = 0.1, liczba iteracji = 2 \n")
simulatedAnnealing(tsp,0.99,100,0.02,20,10)
print("\n")
simulatedAnnealing(tsp,0.99,100,0.02,20,15)
print("\n")
simulatedAnnealing(tsp,0.99,100,0.02,20,20)
print("\n")
simulatedAnnealing(tsp,0.99,100,0.02,20,25)

data_1 = all[3]
data_1 = data_1[2:size(data_1)[1],2:size(data_1)[2]]
#tsp =Copy(data_1)
tsp = dataToArrayOfArrays(data_1)
#tsp, alfa,  staringTemp, finishingTemp, iterationTemp )
print("\n dla 3 excela \n")
simulatedAnnealing(tsp,0.99,500,0.02,20,10)
print("\n")
simulatedAnnealing(tsp,0.99,500,0.02,20,15)
print("\n")
simulatedAnnealing(tsp,0.99,500,0.02,20,20)
print("\n")
simulatedAnnealing(tsp,0.99,500,0.02,20,25)

print("\n dla 4 excela \n")
data_1 = all[4]
data_1 = data_1[2:size(data_1)[1],2:size(data_1)[2]]
#tsp =Copy(data_1)
tsp = dataToArrayOfArrays(data_1)
#tsp, alfa,  staringTemp, finishingTemp, iterationTemp )

simulatedAnnealing(tsp,0.99,500,0.02,20,10)
print("\n")
simulatedAnnealing(tsp,0.99,500,0.02,20,15)
print("\n")
simulatedAnnealing(tsp,0.99,500,0.02,20,20)
print("\n")
simulatedAnnealing(tsp,0.99,500,0.02,20,25)
print("asas")
