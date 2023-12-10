import Random
import Base.read
using Pkg
import XLSX

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
data_1 = all[2]
data_1 = data_1[2:size(data_1)[1],2:size(data_1)[2]]
data_2 = all[3]
data_2 = data_2[2:size(data_2)[1],2:size(data_2)[2]]
data_3 = all[4]
data_3 = data_3[2:size(data_3)[1],2:size(data_3)[2]]



function generateNeighborsByInsertion(currentSolution,n)
    neighbours = []
    IndexOfCities = collect(1:length(currentSolution))
    for i in 1:n
        newSolution = copy(currentSolution)
        city = rand(collect(1:length(newSolution)))
        #Usuwamy miasto o indeksie city z trasy
        deleteat!(newSolution, city) 
        #Generujemy losowy indeks, gdzie miasto będzie wstawione
        insertPosition = rand(1:length(newSolution))
        #Wstawiamy miasto na nowe miejsce
        insert!(newSolution, insertPosition, city)
        push!(neighbours,(newSolution))
        hcat(neighbours)
    end   
    

    return neighbours
end


function dataToArrayOfArrays(data_1)
    tsp = copy(data_1)
    tab=[]
 
    for i in 1:isqrt(length(tsp))

        push!(tab,hcat(data_1[:,i]))
    end       
    #print(tab) 
    #print(length(tab))
    tsp = copy(tab)
    return tsp
end
#tsp = dataToArrayOfArrays(data_1)

print("\n-------------")

function generateRadomSolution(tsp)
    
    IndexOfCities = collect(1:length(tsp))
    solution = []
    for i in 1:length(tsp)
        randomCity = IndexOfCities[Random.rand(1:length(IndexOfCities))]
        push!(solution,randomCity)
        deleteat!(IndexOfCities, findall(x->x==randomCity,IndexOfCities))    
    end
    return   (solution)
end

function CalculateLengthRoute(tsp, solution)
    totalRoadLength = 0
    for i in 1:length(solution)-1 
        totalRoadLength += tsp[solution[i]][solution[i+1]]
    end
    i = length(solution)-1
    totalRoadLength +=tsp[solution[1]][solution[i+1]]  
   
    return totalRoadLength
end


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

function hillClimbing(tsp,n)
    currentSolution = generateRadomSolution(tsp)
    currentTotalRoadLength = CalculateLengthRoute(tsp, currentSolution)
    #neighbours = generateNeighborsByInsertion(currentSolution,n)
    neighbours = generateNeighbours(currentSolution,n)

    bestNeighbour, bestNeighbourTotalRoadLength = getBestNeighbour(tsp, neighbours)

    while bestNeighbourTotalRoadLength < currentTotalRoadLength
        currentSolution = bestNeighbour
        currentTotalRoadLength = bestNeighbourTotalRoadLength
       # neighbours = generateNeighborsByInsertion(currentSolution,n)
        neighbours = generateNeighbours(currentSolution)

        bestNeighbour, bestNeighbourTotalRoadLength = getBestNeighbour(tsp, neighbours)
    end    
    return currentSolution, currentTotalRoadLength
end

function multiStart(tsp, n, starts)
    solution, roadLength = hillClimbing(tsp,n)
    for i in 1:(starts-1)
        newSolution, newRoadLength = hillClimbing(tsp,n)
        if(newRoadLength<roadLength)
            roadLength = newRoadLength
            solution = newSolution
        end
    end  
    print("\n najlepsze \n")
    print(solution)
    print(roadLength)
    return solution, roadLength  
end 


#wyniki dla swap
print("dla 5 sasiadów, 6 starty, excel 1  \n")
print("\n")
print("\n")
multiStart(dataToArrayOfArrays(data_2),5,1)
print("asas")
# print("Dane dla excela TSP_76")

# #tsp =Copy(data_1)
# # tsp = dataToArrayOfArrays(data_1)
# # hillClimbing(dataToArrayOfArrays(data_1), 5)

# print("dla 6 startów, 5 sąsiadów, insertion")
# print("\n")
# multiStart(dataToArrayOfArrays(data_1), 5, 6)
# print("\n")
# print("\n")
# print("\n")

# print("dla 4 startów, 25 sąsiadów, insertion")
# print("\n")
# multiStart(dataToArrayOfArrays(data_2), 25, 4)
# print("\n")
# print("\n")
# print("\n")

# print("dla 6 startów, 10 sąsiadów, insertion")
# print("\n")
# multiStart(dataToArrayOfArrays(data_3), 10, 6)
# print("\n")
# print("\n")
# print("\n")


#000000000000000000000000000000000000000000000000000000000000000

print("dla 5 sasiadów, 6 starty, excel 1  \n")
print("\n")
print("\n")
multiStart(dataToArrayOfArrays(data_3),5,6)
print("dla 10 sasiadów,6 starty, excel 1 \n")
print("\n")
print("\n")
multiStart(dataToArrayOfArrays(data_3),10,6)
print("dla 25 sasiadów, 6 starty, excel 1  \n")
print("\n")
print("\n")
print("dla 25 sasiadów, 6 starty, excel 1  \n")
multiStart(dataToArrayOfArrays(data_3),25,6)
print("\n")
print("\n")
print("dla 25 sasiadów, 6 starty, excel 1  \n")
multiStart(dataToArrayOfArrays(data_3),60,6)
print("\n")
#00000000000000000000000000000000000000000000




print("\n")
print("\n")
print("Badanie wpływu liczby startów na wynik przy stałym sąsiedztwie \n")
print("EXCECL 1\n")
data_1 = all[1]
data_1 = data_1[2:size(data_1)[1],2:size(data_1)[2]]
#tsp =Copy(data_1)
tsp = dataToArrayOfArrays(data_1)
print("dla 3 startów rozmiar sądzie 25\n")
multiStart(tsp,25,3)

print("dla 5 startów rozmiar sądzie 25\n")
multiStart(tsp,25,5)

print("dla 7 startów rozmiar sądzie 25\n")
multiStart(tsp,25,7)

print("EXCECL 2\n")
data_1 = all[2]
data_1 = data_1[2:size(data_1)[1],2:size(data_1)[2]]
#tsp =Copy(data_1)
tsp = dataToArrayOfArrays(data_1)
print("dla 3 startów rozmiar sądzie 25\n")
multiStart(tsp,25,3)

print("dla 5 startów rozmiar sądzie 25\n")
multiStart(tsp,25,5)

print("dla 7 startów rozmiar sądzie 25\n")
multiStart(tsp,25,7)

print("EXCECL 3\n")
data_1 = all[3]
data_1 = data_1[2:size(data_1)[1],2:size(data_1)[2]]
#tsp =Copy(data_1)
tsp = dataToArrayOfArrays(data_1)
print("dla 3 startów rozmiar sądzie 25\n")
multiStart(tsp,25,3)

print("dla 5 startów rozmiar sądzie 25\n")
multiStart(tsp,25,5)

print("dla 7 startów rozmiar sądzie 25\n")
multiStart(tsp,25,7)

print("EXCECL 4\n")
data_1 = all[4]
data_1 = data_1[2:size(data_1)[1],2:size(data_1)[2]]
#tsp =Copy(data_1)
tsp = dataToArrayOfArrays(data_1)
print("dla 3 startów rozmiar sądzie 25\n")
multiStart(tsp,25,3)

print("dla 5 startów rozmiar sądzie 25\n")
multiStart(tsp,25,5)

print("dla 7 startów rozmiar sądzie 25\n")
multiStart(tsp,25,7)







