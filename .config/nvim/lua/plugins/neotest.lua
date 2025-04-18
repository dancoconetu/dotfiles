return {
	{ "nvim-neotest/neotest-plenary" },

	{ "Issafalcon/neotest-dotnet" },
	{
		"nvim-neotest/neotest",
		opts = { adapters = { "neotest-plenary", "neotest-dotnet" } },
	},
}
