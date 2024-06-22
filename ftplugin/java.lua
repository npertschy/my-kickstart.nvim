-- Java Language Server configuration.
-- Locations:
-- 'nvim/ftplugin/java.lua'.

local jdtls_ok, jdtls = pcall(require, 'jdtls')
if not jdtls_ok then
  vim.notify 'JDTLS not found, install with `:LspInstall jdtls`'
  return
end

-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local mason_path = vim.fn.stdpath 'data' .. '/mason/packages'
local jdtls_path = mason_path .. '/jdtls'
local path_to_lsp_server = jdtls_path .. '/config_win'
local path_to_jar = vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar')
local lombok_path = jdtls_path .. '/lombok.jar'
local java_debug_path = vim.fn.glob(mason_path .. '/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar')

local root_markers = { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' }
local root_dir = require('jdtls.setup').find_root(root_markers)
if root_dir == '' then
  return
end

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = vim.fn.stdpath 'data' .. '/site/java/workspace-root/' .. project_name
os.execute('mkdir ' .. workspace_dir)

local cmp_nvim_lsp = require 'cmp_nvim_lsp'
local client_capabilities = vim.lsp.protocol.make_client_capabilities()
local capabilities = cmp_nvim_lsp.default_capabilities(client_capabilities)

-- Main Config
local config = {
  capabilities = capabilities,
  -- The command that starts the language server
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = {
    'C:/Users/npertschy/.jdks/temurin-21.0.1/bin/java.exe',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-javaagent:' .. lombok_path,
    '-Xms2g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens',
    'java.base/java.util=ALL-UNNAMED',
    '--add-opens',
    'java.base/java.lang=ALL-UNNAMED',
    '-jar',
    path_to_jar,
    '-configuration',
    path_to_lsp_server,
    '-data',
    workspace_dir,
  },

  -- This is the default if not provided, you can remove it. Or adjust as needed.
  -- One dedicated LSP server & client will be started per unique root_dir
  root_dir = root_dir,

  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
    java = {
      home = 'C:/Users/npertschy/.jdks/temurin-21.0.1',
      eclipse = {
        downloadSources = true,
      },
      configuration = {
        updateBuildConfiguration = 'interactive',
        runtimes = {
          {
            name = 'JavaSE-21',
            path = 'C:/Users/npertschy/.jdks/temurin-21.0.1',
          },
        },
      },
      maven = {
        downloadSources = true,
      },
      implementationsCodeLens = {
        enabled = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      references = {
        includeDecompiledSources = true,
      },
      format = {
        enabled = true,
        settings = {
          url = 'C:/Users/npertschy/Desktop/googlestyle.xml',
          profile = 'GoogleStyle',
        },
      },
    },
    signatureHelp = { enabled = true },
    completion = {
      favoriteStaticMembers = {
        'org.hamcrest.MatcherAssert.assertThat',
        'org.hamcrest.Matchers.*',
        'org.hamcrest.CoreMatchers.*',
        'org.junit.jupiter.api.Assertions.*',
        'java.util.Objects.requireNonNull',
        'java.util.Objects.requireNonNullElse',
        'org.mockito.Mockito.*',
      },
      importOrder = {
        'java',
        'javax',
        'com',
        'org',
      },
    },
    sources = {
      organizeImports = {
        starThreshold = 9999,
        staticStarThreshold = 9999,
      },
    },
    codeGeneration = {
      toString = {
        template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
      },
      useBlocks = true,
    },
  },

  flags = {
    allow_incremental_sync = true,
  },
  init_options = {
    extendedClientCapabilities = jdtls.extendedClientCapabilities,
    bundles = {
      java_debug_path,
    },
  },
}

config['on_attach'] = function(client, buffer)
  vim.keymap.set('n', '<leader>co', jdtls.organize_imports, { desc = 'Organize imports', buffer = buffer })
  vim.keymap.set('n', '<leader>cv', jdtls.extract_variable_all, { desc = 'Extract variable and replace all occurrences', buffer = buffer })
  vim.keymap.set(
    'v',
    '<leader>cv',
    '<ESC><CMD>lua require("jdtls").extract_variable_all(true)<CR>',
    { desc = 'Extract variable and replace all occurrences', buffer = buffer }
  )
  vim.keymap.set('n', '<leader>cc', jdtls.extract_constant, { desc = 'Extract constant', buffer = buffer })
  vim.keymap.set('v', '<leader>cc', '<ESC><CMD>lua require("jdtls").extract_constant(true)<CR>', { desc = 'Extract constant', buffer = buffer })
  vim.keymap.set('n', '<leader>cm', jdtls.extract_method, { desc = 'Extract method', buffer = buffer })
  vim.keymap.set('v', '<leader>cm', '<ESC><CMD>lua require("jdtls").extract_method(true)<CR>', { desc = 'Extract method', buffer = buffer })
  vim.keymap.set('n', '<leader>gt', require('jdtls.tests').goto_subjects, { desc = '[G]oto [T]est', buffer = buffer })
  vim.keymap.set('n', '<leader>rt', function()
    local testClass = vim.fn.expand '%'
    testClass = testClass:gsub('\\', '.'):gsub('src.test', ''):gsub('.java(.?)', '')
    local commandToRun = './gradlew test --tests ' .. testClass .. ' -x jacocoTestCoverageVerification'
    require('toggleterm').exec(commandToRun, 1, 12)
  end, { desc = 'Run test file', buffer = buffer })

  jdtls.setup_dap { hotcodereplace = 'auto', config_overrides = {} }
end

-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
require('jdtls').start_or_attach(config)
