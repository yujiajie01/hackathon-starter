// pnpm 配置文件，用于处理一些包的兼容性问题
function readPackage(pkg, context) {
  // 如果需要，可以在这里修改包的依赖
  return pkg;
}

module.exports = {
  hooks: {
    readPackage,
  },
};

