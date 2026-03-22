local string, math, table, ipairs, pairs, type = string, math, table, ipairs, pairs, type
module("trie")

local compressTree
function Bulid(data)
	local root = {}
	for k, v in pairs(data) do
		local node = root
		for word in string.gmatch(string.utf8lower(k), "[^%.%?!,%-%s]+") do
			node[word] = node[word] or {}
			node = node[word]
		end
		node[1] = v -- терминальный узел
	end

	compressTree(root)
	return root
end

-- Рекурсивно сжимает узлы с одним дочерним элементом (ИИшный код, мне было впадлу думать)
compressTree = function(node)
	if not node then return end

	-- Сначала рекурсивно сжимаем всех детей
	local childKeys = {}
	for k, v in pairs(node) do
		if type(k) == "string" then
			compressTree(v)
			table.insert(childKeys, k)
		end
	end

	-- Если есть только один ребенок и у него нет терминального узла и сжатой последовательности
	if #childKeys == 1 and not node[childKeys[1]][1] and not node[childKeys[1]][2] then
		local singleChildKey = childKeys[1]
		local singleChild = node[singleChildKey]

		-- Создаем сжатую последовательность
		local compressedChain = {singleChildKey}

		-- Проверяем, можно ли продолжить сжатие
	local current = singleChild
		while current do
			local grandChildren = {}
			for k, v in pairs(current) do
				if type(k) == "string" then
					table.insert(grandChildren, k)
				end
			end

			-- Если у текущего узла ровно один ребенок и нет терминального узла
			if #grandChildren == 1 and not current[1] then
				table.insert(compressedChain, grandChildren[1])
				current = current[grandChildren[1]]
			else
				-- Переносим оставшиеся узлы на текущий уровень
				for k, v in pairs(current) do
					node[k] = v
				end
				break
			end
		end

		-- Если сжатая последовательность состоит более чем из одного элемента
		if #compressedChain > 1 then
			-- Удаляем старые дочерние узлы
			for _, key in ipairs(childKeys) do
				node[key] = nil
			end

			-- Создаем сжатую последовательность
			node[2] = compressedChain
		end
	end
end

-- сравнение двух массивов до первого неравенства
local function equal(a, b, from)
	local len = #a
	for i = 1, len do
		if a[i] ~= b[i + from] then return false end
	end
	return len
end

function GetPrefixes(root, words, prefixes, i, max, callback)
	i = i or 1
	max = max or math.huge
	if not prefixes then prefixes = {} end
	local len = #words
	local prefixes_len = #prefixes

	while i <= len and prefixes_len < max do
		local node = root
		local longest = nil
		local depth = i

		-- Ищем самую длинную фразу, начиная с i
		for j = i, len do
			local cur = node[words[j]]
			if not cur then break end -- префикс больше не совпадает

			local len = 0
			if cur[2] then -- необходимо для более плоской таблицы
				len = equal(cur[2], words, j)
				if not len then break end
			end

			node = cur
			if node[1] then
				longest = node[1]
				depth = j + len
			end
		end

		if not longest then break end -- если все сообщение не подходит под префиксную, перестать искать
		i = depth + 1 -- переходим к следующему слову после найденной фразы

		if callback and callback(longest) == false then continue end -- пропуск фразы при повторах или большой длительности
		prefixes_len = prefixes_len + 1
		prefixes[prefixes_len] = longest
	end

	return prefixes, i
end

function Prepare(str)
	local tbl, len = {}, 0
	for word in string.gmatch(string.utf8lower(str), "[^%.%?!,%-%s]+") do
		len = len + 1
		tbl[len] = word
	end
	return tbl
end