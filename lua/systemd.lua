local syntax = vim.api.nvim_create_namespace("systemd")

local function set_highlight(group, properties)
	vim.api.nvim_set_hl(0, group, properties)
end

local function syntax_match(group, pattern, contained)
	vim.fn.matchadd(group, pattern, 10, -1, { contained = contained })
end

local function syntax_keyword(group, keywords, contained)
	for _, keyword in ipairs(keywords) do
		vim.fn.matchadd(group, "\\<" .. keyword .. "\\>", 10, -1, { contained = contained })
	end
end

local function syntax_region(group, start_pattern, end_pattern, contained_groups)
	vim.fn.matchaddpos(group, { start_pattern, end_pattern }, 10, -1, { contained = contained_groups })
end

-- Syntax definitions
vim.cmd("syntax case match")
vim.cmd("syntax sync fromstart")
vim.cmd("setlocal iskeyword+=-")

-- Special sequences, common data types, comments, includes
syntax_match("sdErr", "\\s*\\S\\+", true)
syntax_match("sdEnvArg", "\\$\\i\\+\\|\\${\\i\\+}", true)
syntax_match("sdFormatStr", "%[bCEfhHiIjJLmnNpPsStTgGuUvV%]", true)

syntax_match("sdUInt", "\\d\\+", true)
syntax_match("sdInt", "-\\=\\d\\+", true)
syntax_match("sdOctal", "0\\o\\{3,4}", true)
syntax_match("sdDuration", "\\d\\+", true)
syntax_match(
	"sdDuration",
	"\\%(\\d\\+\\s*\\%(usec\\|msec\\|seconds\\=\\|minutes\\=\\|hours\\=\\|days\\=\\|weeks\\=\\|months\\=\\|years\\=\\|us\\|ms\\|sec\\|min\\|hr\\|[smhdwMy]\\)\\s*\\)\\+",
	true
)
syntax_match("sdDatasize", "\\d\\+[KMGT]", true)
syntax_match("sdFilename", "\\/\\S*", true)
syntax_match("sdPercent", "\\d\\+%", true)
syntax_keyword("sdBool", { "yes", "true", "on", "no", "false", "off" }, true)
syntax_match(
	"sdUnitName",
	"\\S\\+\\.\\(automount\\|mount\\|swap\\|socket\\|service\\|target\\|path\\|timer\\|device\\|slice\\|scope\\)\\_s",
	false
)

-- .include
syntax_match("sdInclude", "^.include", true)
syntax_match("sdInclude", "/^#.*/", true)

-- Comments
syntax_match("sdComment", "^[;#].*", true)
syntax_keyword("sdTodo", { "TODO", "XXX", "FIXME", "NOTE" }, true)

-- [Unit]
syntax_region("sdUnitBlock", "^\\[Unit\\]", "^\\[", { "sdUnitKey" })
syntax_match("sdUnitKey", "^Description=", true)
syntax_match("sdUnitKey", "^Documentation=", true)
syntax_match("sdUnitKey", "^SourcePath=", true)
syntax_match("sdUnitKey", "^RequiresMountsFor=", true)

-- Execution options common to [Service|Socket|Mount|Swap]
syntax_match("sdExecKey", "^Exec\\%(Start\\%(Pre\\|Post\\|\\)\\|Reload\\|Stop\\|StopPost\\|Condition\\)=", true)
syntax_match("sdExecKey", "^User=", true)
syntax_match("sdExecKey", "^Group=", true)

-- Process killing options for [Service|Socket|Mount|Swap|Scope]
syntax_match("sdKillKey", "^KillSignal=", true)
syntax_match("sdKillKey", "^KillMode=", true)

-- Resource Control options for [Service|Socket|Mount|Swap|Slice|Scope]
syntax_match("sdResCtlKey", "^Slice=", true)
syntax_match("sdResCtlKey", "^CPUAccounting=", true)
syntax_match("sdResCtlKey", "^MemoryAccounting=", true)

-- [Service]
syntax_region("sdServiceBlock", "^\\[Service\\]", "^\\[", { "sdServiceKey", "sdExecKey", "sdKillKey", "sdResCtlKey" })
syntax_match("sdServiceKey", "^BusName=", true)
syntax_match("sdServiceKey", "^RemainAfterExit=", true)
syntax_match("sdServiceKey", "^Restart=", true)

-- [Socket]
syntax_region("sdSocketBlock", "^\\[Socket\\]", "^\\[", { "sdSocketKey", "sdExecKey", "sdKillKey", "sdResCtlKey" })
syntax_match(
	"sdSocketKey",
	"^Listen\\%(Stream\\|Datagram\\|SequentialPacket\\|FIFO\\|Special\\|Netlink\\|MessageQueue\\)=",
	true
)

-- [Timer|Automount|Mount|Swap|Path|Slice|Scope]
syntax_region("sdTimerBlock", "^\\[Timer\\]", "^\\[", { "sdTimerKey" })
syntax_match("sdTimerKey", "^On\\%(Active\\|Boot\\|Startup\\|UnitActive\\|UnitInactive\\)Sec=", true)

-- Coloring definitions
set_highlight("sdComment", { link = "Comment" })
set_highlight("sdTodo", { link = "Todo" })
set_highlight("sdInclude", { link = "PreProc" })
set_highlight("sdHeader", { link = "Type" })
set_highlight("sdEnvArg", { link = "PreProc" })
set_highlight("sdFormatStr", { link = "Special" })
set_highlight("sdErr", { link = "Error" })
set_highlight("sdEnvDef", { link = "Identifier" })
set_highlight("sdKey", { link = "Statement" })
set_highlight("sdValue", { link = "Constant" })
set_highlight("sdSymbol", { link = "Special" })

-- Coloring links: keys
set_highlight("sdUnitKey", { link = "sdKey" })
set_highlight("sdExecKey", { link = "sdKey" })
set_highlight("sdKillKey", { link = "sdKey" })
set_highlight("sdResCtlKey", { link = "sdKey" })
set_highlight("sdServiceKey", { link = "sdKey" })
set_highlight("sdSocketKey", { link = "sdKey" })
set_highlight("sdTimerKey", { link = "sdKey" })

-- Coloring links: constant values
set_highlight("sdInt", { link = "sdValue" })
set_highlight("sdUInt", { link = "sdValue" })
set_highlight("sdBool", { link = "sdValue" })
set_highlight("sdOctal", { link = "sdValue" })
set_highlight("sdDuration", { link = "sdValue" })
set_highlight("sdPercent", { link = "sdValue" })
set_highlight("sdDatasize", { link = "sdValue" })
set_highlight("sdVirtType", { link = "sdValue" })
set_highlight("sdServiceType", { link = "sdValue" })
set_highlight("sdNotifyType", { link = "sdValue" })
set_highlight("sdSecurityType", { link = "sdValue" })
set_highlight("sdSecureBits", { link = "sdValue" })
set_highlight("sdMountFlags", { link = "sdValue" })
set_highlight("sdKillMode", { link = "sdValue" })
set_highlight("sdFailJobMode", { link = "sdValue" })
set_highlight("sdLimitAction", { link = "sdValue" })
set_highlight("sdRestartType", { link = "sdValue" })
set_highlight("sdSignal", { link = "sdValue" })
set_highlight("sdStdin", { link = "sdValue" })
set_highlight("sdStdout", { link = "sdValue" })
set_highlight("sdSyslogFacil", { link = "sdValue" })
set_highlight("sdSyslogLevel", { link = "sdValue" })
set_highlight("sdIOSched", { link = "sdValue" })
set_highlight("sdCPUSched", { link = "sdValue" })
set_highlight("sdRlimit", { link = "sdValue" })
set_highlight("sdCapName", { link = "sdValue" })
set_highlight("sdDevPolicy", { link = "sdValue" })
set_highlight("sdDevAllowPerm", { link = "sdValue" })
set_highlight("sdDevAllowErr", { link = "Error" })

-- Coloring links: symbols/flags
set_highlight("sdExecFlag", { link = "sdSymbol" })
set_highlight("sdConditionFlag", { link = "sdSymbol" })
set_highlight("sdEnvDashFlag", { link = "sdSymbol" })
set_highlight("sdCapOps", { link = "sdSymbol" })
set_highlight("sdCapFlags", { link = "Identifier" })

vim.b.current_syntax = "systemd"
