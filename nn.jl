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

############    Nearest Neighbours    ############ 

function nearest_neighbours(data, y)
    visited = zeros(1, size(data)[1])
    result = zeros(1, size(data)[1])

    if y<=0 || y>size(data)[1]
        println("Incorrect start point")
        return
    end
    k=y
    visited[k]=1
    result[1]=k
    s = 0
    for j in 1:size(data)[1]-1
        for j in 1:size(data)[1]
            if visited[j]==0
                s=j
                break
            end
        end
        for i in s:size(data)[1]
            if data[i, k] <= data[s, k] && data[i, k] > 0 && visited[i] == 0
                s = i
            end
        end
        visited[s] = 1
        k=s
        result[j+1]=s
    end
    return result
end


function setZerosOnDiagonalOfTheMatrix(data)
    for j in 2:size(data)[1]
        for i in 2:size(data)[1]
            if i==j
                data[i, j] = 0
            end
        end
    end
    return data
end

function getDistance(symmetric,city1,city2)
    return symmetric[city1,city2]
end

function getRouteDistance(symmetric, route)
    distance = 0
    for city in 1:length(route)-1
        distance += getDistance(symmetric,route[city],route[city+1])
    end
    distance += getDistance(symmetric, route[1],route[length(route)]) # last city to city of origin 
    return distance
end

function deleteFirstRowAndColumn(file)
    return file[2:size(file)[1],2:size(file)[2]]
end

function printResult(fileName, startPoint, route, distance)
    println("File: $(fileName), start point: $(startPoint), route: $(route), distance: $(round(distance, digits=2))")
    println("\n")
end


data1 = deleteFirstRowAndColumn(all[1])

route = nearest_neighbours(data1, 3)
distance = getRouteDistance(data1, Int.(route))
printResult(FILES[1], 3, route, distance)

route = nearest_neighbours(data1, 6)
distance = getRouteDistance(data1, Int.(route))
printResult(FILES[1], 6, route, distance)

route = nearest_neighbours(data1, 9)
distance = getRouteDistance(data1, Int.(route))
printResult(FILES[1], 9, route, distance)

route = nearest_neighbours(data1, 24)
distance = getRouteDistance(data1, Int.(route))
printResult(FILES[1], 24, route, distance)


data2 = deleteFirstRowAndColumn(all[2])

route = nearest_neighbours(data2, 3)
distance = getRouteDistance(data2, Int.(route))
printResult(FILES[2], 3, route, distance)

route = nearest_neighbours(data2, 14)
distance = getRouteDistance(data2, Int.(route))
printResult(FILES[2], 14, route, distance)

route = nearest_neighbours(data2, 24)
distance = getRouteDistance(data2, Int.(route))
printResult(FILES[2], 24, route, distance)

route = nearest_neighbours(data2, 34)
distance = getRouteDistance(data2, Int.(route))
printResult(FILES[2], 34, route, distance)

correctMatrix = setZerosOnDiagonalOfTheMatrix(all[3])
data3 = deleteFirstRowAndColumn(correctMatrix)

route = nearest_neighbours(data3, 11)
distance = getRouteDistance(data3, Int.(route))
printResult(FILES[3], 11, route, distance)

route = nearest_neighbours(data3, 31)
distance = getRouteDistance(data3, Int.(route))
printResult(FILES[3], 31, route, distance)

route = nearest_neighbours(data3, 51)
distance = getRouteDistance(data3, Int.(route))
printResult(FILES[3], 51, route, distance)

route = nearest_neighbours(data3, 71)
distance = getRouteDistance(data3, Int.(route))
printResult(FILES[3], 71, route, distance)


data4 = deleteFirstRowAndColumn(all[4])

route = nearest_neighbours(data4, 9)
distance = getRouteDistance(data4, Int.(route))
printResult(FILES[4], 9, route, distance)

route = nearest_neighbours(data4, 39)
distance = getRouteDistance(data4, Int.(route))
printResult(FILES[4], 39, route, distance)

route = nearest_neighbours(data4, 68)
distance = getRouteDistance(data4, Int.(route))
printResult(FILES[4], 68, route, distance)

route = nearest_neighbours(data4, 99)
distance = getRouteDistance(data4, Int.(route))
printResult(FILES[4], 99, route, distance)