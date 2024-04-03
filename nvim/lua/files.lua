local function exists(file)
  local ok, err, code = os.rename(file, file)
  if not ok then
    if code == 13 then
      return true
    end
  end
  return ok, err
end

local function isdir(path)
  return exists(path .. "/")
end

return {
  isdir = isdir,
  exists = exists,
}
