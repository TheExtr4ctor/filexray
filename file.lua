-- ASCII Art Header
local function print_header()
    print([[
  ____  __  __  ____   __  ___  ____  _____  ____  
  ______ __   __ _______  _____   _  _     _____  _______   ____   _____  
|  ____|\ \ / /|__   __||  __ \ | || |   / ____||__   __| / __ \ |  __ \ 
| |__    \ V /    | |   | |__) || || |_ | |        | |   | |  | || |__) |
|  __|    > <     | |   |  _  / |__   _|| |        | |   | |  | ||  _  / 
| |____  / . \    | |   | | \ \    | |  | |____    | |   | |__| || | \ \ 
|______|/_/ \_\   |_|   |_|  \_\   |_|   \_____|   |_|    \____/ |_|  \_\
                                                                         
                                                                         

                                                 
    ]])
end

-- Function to display the welcome message
local function print_welcome_message()
    print("Welcome to FileXray")
    print("Please choose an option:")
    print("1. Analyze file for anomalies")
    print("2. Exit")
end

-- Function to check if a file exists
local function file_exists(file_path)
    local file = io.open(file_path, "rb")
    if file then
        file:close()
        return true
    else
        return false
    end
end

-- Function to read a file
local function read_file(file_path)
    local file = io.open(file_path, "rb") -- Open file in binary mode
    if not file then
        return nil, "Cannot open file: " .. file_path
    end
    local content = file:read("*all") -- Read entire file content
    file:close()
    return content
end

-- Function to get a snippet of the file around an anomaly
local function get_snippet(content, position, context)
    local start_pos = math.max(position - context, 1)
    local end_pos = math.min(position + context, #content)
    return content:sub(start_pos, end_pos)
end

-- Function to calculate the entropy of a byte sequence
local function calculate_entropy(data)
    local frequency = {}
    local data_len = #data

    for i = 1, data_len do
        local byte = data:sub(i, i)
        frequency[byte] = (frequency[byte] or 0) + 1
    end

    local entropy = 0
    for _, count in pairs(frequency) do
        local p = count / data_len
        entropy = entropy - p * math.log(p) / math.log(2)
    end

    return entropy
end

-- Function to detect patterns
local function detect_patterns(data, pattern_length)
    local patterns = {}
    local data_len = #data

    for i = 1, data_len - pattern_length + 1 do
        local pattern = data:sub(i, i + pattern_length - 1)
        patterns[pattern] = (patterns[pattern] or 0) + 1
    end

    local anomaly_patterns = {}
    for pattern, count in pairs(patterns) do
        if count > 1 then
            table.insert(anomaly_patterns, {pattern = pattern, count = count})
        end
    end

    return anomaly_patterns
end

-- Function to analyze the file for anomalies
local function analyze_file(file_path)
    local content, err = read_file(file_path)
    if not content then
        print(err)
        return
    end

    -- Basic anomaly detection logic
    local anomalies = {}
    local total_bytes = #content

    -- Check for unusual characters
    for i = 1, total_bytes do
        local byte = string.byte(content, i)
        if byte < 32 or byte > 126 then
            table.insert(anomalies, {position = i, type = "Unusual Character", byte = byte})
        end
    end

    -- Entropy threshold (example: 7.5)
    local entropy_threshold = 7.5
    -- Context for snippet around anomalies
    local context = 10

    -- Check for high entropy regions
    local window_size = 256
    for i = 1, total_bytes - window_size + 1, window_size do
        local window = content:sub(i, i + window_size - 1)
        local entropy = calculate_entropy(window)
        if entropy > entropy_threshold then
            table.insert(anomalies, {position = i, type = "High Entropy", value = entropy})
        end
    end

    -- Check for repeated patterns
    local pattern_length = 4
    local patterns = detect_patterns(content, pattern_length)
    for _, pattern in ipairs(patterns) do
        table.insert(anomalies, {type = "Repeated Pattern", pattern = pattern.pattern, count = pattern.count})
    end

    -- Display results
    print("Analyzing file:", file_path)
    print("Total bytes:", total_bytes)
    print("Anomalies found:", #anomalies)

    if #anomalies > 0 then
        print("Anomaly details:")
        for _, anomaly in ipairs(anomalies) do
            if anomaly.type == "Unusual Character" then
                local snippet = get_snippet(content, anomaly.position, context)
                print(string.format("Position: %d, Type: %s, Byte: %d", anomaly.position, anomaly.type, anomaly.byte))
                print("Context:", snippet)
            elseif anomaly.type == "High Entropy" then
                local snippet = content:sub(anomaly.position, anomaly.position + window_size - 1)
                print(string.format("Position: %d, Type: %s, Entropy: %.2f", anomaly.position, anomaly.type, anomaly.value))
                print("Context:", snippet)
            elseif anomaly.type == "Repeated Pattern" then
                print(string.format("Pattern: %s, Count: %d", anomaly.pattern, anomaly.count))
            end
        end
    else
        print("No anomalies detected.")
    end
end

-- Function to handle file analysis menu option
local function handle_analyze_file_option()
    io.write("Enter the file path: ")
    local file_path = io.read()

    -- Check if the file exists
    if not file_exists(file_path) then
        print("File does not exist:", file_path)
        return
    end

    -- Analyze the file
    analyze_file(file_path)
end

-- Main function to display the menu and handle user input
local function main()
    print_header()

    while true do
        print_welcome_message()
        io.write("Select an option (1-2): ")
        local choice = io.read()

        if choice == "1" then
            handle_analyze_file_option()
        elseif choice == "2" then
            print("Exiting FileXray. Goodbye!")
            break
        else
            print("Invalid option. Please select a valid option (1-2).")
        end
    end
end

-- Run the main function
main()
