if vim.fn.has('mac') == 1 then
	Macos = true
	Linux = false
	Windows = false
elseif vim.fn.has('unix') == 1 then
	Macos = false
	Linux = true
	Windows = false
elseif vim.fn.has('win32') == 1 then
	Macos = false
	Linux = false
	Windows = true
end

return {
	is_macos = Macos,
	is_linux = Linux,
	is_windows = Windows,
}
