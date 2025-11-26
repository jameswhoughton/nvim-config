return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  config = function()
    local conform = require("conform")

    --------------------------------------------------------------------------
    -- Detect whether Pint exists in the project
    --------------------------------------------------------------------------
    local function pint_exists()
      local buf = vim.api.nvim_get_current_buf()
      local file = vim.api.nvim_buf_get_name(buf)

      -- Find project root using Laravel markers
      local root = vim.fs.root(file, {
        "pint.json",
        "composer.json",
        "artisan",
        "vendor",
      })

      if not root then
        return nil
      end

      -- Check local Pint binary
      local local_pint = root .. "/vendor/bin/pint"
      if vim.fn.filereadable(local_pint) == 1 then
        return local_pint
      end

      -- If pint.json exists AND global "pint" executable exists
      local has_pint_json = vim.fn.filereadable(root .. "/pint.json") == 1
      if has_pint_json and vim.fn.executable("pint") == 1 then
        return "pint"
      end

      return nil
    end

    --------------------------------------------------------------------------
    -- Conform setup
    --------------------------------------------------------------------------
    conform.setup({
      formatters_by_ft = {
        php = function()
          if pint_exists() then
            return { "pint_local" }
          else
            return { "intelephense" }
          end
        end,

        blade = function()
          return pint_exists() and { "pint_local" } or {}
        end,

        ["blade.php"] = function()
          return pint_exists() and { "pint_local" } or {}
        end,
      },

      format_on_save = function(bufnr)
        local ft = vim.bo[bufnr].filetype
        if ft == "php" or ft == "blade" or ft == "blade.php" then
          return { timeout_ms = 3000, lsp_fallback = true }
        end
      end,
    })

    --------------------------------------------------------------------------
    -- Pint formatter
    --------------------------------------------------------------------------
    conform.formatters.pint_local = {
      command = function()
        return pint_exists()
      end,
      args = { "$FILENAME" },
      stdin = false,
    }
  end,
}
