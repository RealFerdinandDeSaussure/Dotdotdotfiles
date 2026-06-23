require 'mp.msg'

mp.set_property("user-data/active-scripts/qr-scan", mp.get_script_name())

local function get_qr_string()
    local tmpfile = os.tmpname()
    mp.command_native({name="screenshot-to-file", filename = tmpfile, _flags={"osd-bar"}})
    local out = mp.command_native({name = "subprocess", args = {"qrtool", "decode", tmpfile}, capture_stdout = true})
    os.remove(tmpfile)
    return out.stdout
end

local function decode_qr()
    local qrs = get_qr_string()
    if qrs ~= "" then
        mp.commandv("print-text", qrs)
    end
end

local function decode_qr_to_clipboard()
    local qrs = get_qr_string()
    if qrs ~= "" then
        mp.set_property("clipboard/text", qrs)
    end
end

local function decode_qr_to_prop()
	local qrs = get_qr_string()
    if qrs ~="" then
        mp.set_property("user-data/decode-qr", qrs)
    end
end

mp.register_script_message("decode-qr-to-prop", decode_qr_to_prop)
mp.add_key_binding(nil, "decode-qr", decode_qr)
mp.add_key_binding(nil, "decode-qr-to-clipboard", decode_qr_to_clipboard)
