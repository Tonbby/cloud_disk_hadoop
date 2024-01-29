package com.cosyblogs.cloud.disk.controller;

import com.cosyblogs.cloud.disk.common.ApiResult;
import com.cosyblogs.cloud.disk.service.FileService;
import com.cosyblogs.cloud.disk.service.HDFSService;

import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.Resource;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;


import java.io.*;
import java.net.URLEncoder;

@RestController
@RequestMapping("/hdfs")
public class HDFSController {

	@Autowired
	private HDFSService hdfsService;
	@Autowired
	private FileService fileService;

	// http://localhost:8080/hdfs/mkdirs?dirs=/hdfs/a/b/c/
	@GetMapping("/mkdirs")
	public ApiResult mkdirs(@RequestParam("dirs") String dirs) {
		return this.hdfsService.mkdirs(dirs);
	}

	// http://localhost:8080/hdfs/upload
	@PostMapping("/upload")
	public ApiResult upload(@RequestParam("file") MultipartFile file) {
		ApiResult apiResult = null;
		try {
			apiResult = this.hdfsService.upload(file.getOriginalFilename(), file.getInputStream());
		} catch (IOException e) {
			e.printStackTrace();
			apiResult = ApiResult.failure("Operate Failure !");
		}
		return apiResult;
	}

	// http://localhost:8080/hdfs/delete?fileName=
	@GetMapping("/delete")
	public ApiResult delete(@RequestParam("fileName") String fileName) {
		return this.hdfsService.delete(fileName);
	}

	// http://localhost:8080/hdfs/rename?oldStr= &newStr=
	@GetMapping("/rename")
	public ApiResult rename(@RequestParam("oldStr") String oldStr, @RequestParam("newStr") String newStr) {
		return this.hdfsService.rename(oldStr, newStr);
	}

	// http://localhost:8080/hdfs/exists?fileName=
	@GetMapping("/exists")
	public ApiResult exists(@RequestParam("fileName") String fileName) {
		return this.hdfsService.exists(fileName);
	}

	// http://localhost:8080/hdfs/download?fileName=
	@GetMapping(value = "/download")
	public ResponseEntity<byte[]> download(@RequestParam("fileName") String fileName) throws Exception {
		File file=new File(fileName);
		String downloadName = file.getName();
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
		headers.setContentDispositionFormData("attachment", URLEncoder.encode(downloadName, "UTF-8"));
		InputStream input = this.hdfsService.download(fileName);
		return new ResponseEntity<byte[]>(IOUtils.toByteArray(input), headers, HttpStatus.OK);
	}

	// http://localhost:8080/hdfs/preview?fid=
	@GetMapping(value = "/preview")
	public ResponseEntity<Resource> preview(@RequestParam("fid") Integer fid) throws Exception {
		String fileName=new String();
		if (fid!=null){
			fileName = fileService.getFileByFileId(fid).getFpath();
		}
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_PDF);
		headers.setContentDispositionFormData("attachment", URLEncoder.encode(fileName, "UTF-8"));
		InputStream input = this.hdfsService.download(fileName);
		byte[] data = IOUtils.toByteArray(input);
		ByteArrayResource resource = new ByteArrayResource(data);
		return ResponseEntity.ok()
				.headers(headers)
				.contentLength(data.length)
				.body(resource);
	}



	@RequestMapping(value = "/previewFile", method = RequestMethod.GET)
	@ResponseBody
	public InputStream previewFile(@RequestParam("fileName") String fileName){
		return this.hdfsService.download(fileName);

	}
	// http://localhost:8080/hdfs/list?path=
	@GetMapping("/list")
	public ApiResult list(@RequestParam("path") String path) {
		return this.hdfsService.list(path);
	}
}
