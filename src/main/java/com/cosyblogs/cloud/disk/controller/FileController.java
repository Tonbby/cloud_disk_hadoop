package com.cosyblogs.cloud.disk.controller;

import com.cosyblogs.cloud.disk.common.ApiCodeConstant;
import com.cosyblogs.cloud.disk.common.ApiResult;
import com.cosyblogs.cloud.disk.model.File;
import com.cosyblogs.cloud.disk.model.Fpage;
import com.cosyblogs.cloud.disk.model.Pagination;
import com.cosyblogs.cloud.disk.model.User;
import com.cosyblogs.cloud.disk.service.FileService;
import com.cosyblogs.cloud.disk.service.FpageService;
import com.cosyblogs.cloud.disk.service.HDFSService;

import java.io.BufferedInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.multipart.MultipartFile;

@Controller
@RequestMapping("/file")
public class FileController {

    @Autowired
    private FileService fileService;
    @Autowired
    private HDFSService hdfsService;
    @Autowired
    private FpageService fpageService;
    @Autowired
    private ServletRequest request;

    // http://localhost:8080/disk/user/getUsers
    @GetMapping("/getFiles")
    @ResponseBody
    public Pagination<File> getFiles(Pagination page) {
        int ffolder = Integer.parseInt(request.getParameter("ffolder"));
        int fowner = Integer.parseInt(request.getParameter("fowner"));
        return this.fileService.getFiles(page, ffolder, fowner);
    }

    // http://localhost:8080/disk/user/insertUsers
    @PostMapping("/insertFile")
    @ResponseBody
    public ApiResult insertFile(@RequestParam("file") MultipartFile file, File f, HttpSession session) throws IOException {
//        User user = (User) session.getAttribute("user");
//        String path = f.getFpath() + user.getUsername() + "/" + file.getOriginalFilename();
        String path = f.getFpath()  + file.getOriginalFilename();
        ApiResult result = this.hdfsService.upload(path, file.getInputStream());
        if (result.getCode() == ApiCodeConstant.RESULT_SUCC) {
            f.setFname(file.getOriginalFilename());
            f.setFsize(file.getSize());
            f.setFpath(path);
            f.setFsuffix(file.getOriginalFilename().substring(file.getOriginalFilename().lastIndexOf(".")));
            int flag = this.fileService.insertFile(f);
            if (flag > 0) {
                return ApiResult.success();
            } else
                this.hdfsService.delete(path);

        }
        return ApiResult.failure("operate Failure !");

    }

    @GetMapping("/deleteFile")
    @ResponseBody
    public ApiResult deleteFile(@RequestParam("fid") int fid) {
        return this.fileService.deleteFile(fid);
    }

    @GetMapping("/deleteFiles")
    @ResponseBody
    public ApiResult deleteFiles(@RequestParam("fids") String fids) {
        return this.fileService.deleteFiles(fids);
    }

    @PostMapping("/updateFile")
    @ResponseBody
    public ApiResult updateFile(@RequestParam("fname") String fname, @RequestParam("fid") int fid,
                                @RequestParam("fpath") String fpath) {

        String newfname = fname + fpath.substring(fpath.lastIndexOf("."));
        String temp = fpath.substring(0, fpath.lastIndexOf("/") + 1);
        String newfpath = temp + newfname;
        ApiResult result = this.hdfsService.rename(fpath, newfpath);

        if (result.getCode() == ApiCodeConstant.RESULT_SUCC) {
            HashMap<String, Object> map = new HashMap<String, Object>();
            map.put("fid", fid);
            map.put("fname", newfname);
            map.put("fpath", newfpath);
            return this.fileService.updateFile(map);
        }
        return ApiResult.failure("operate Failure !");

    }

    @GetMapping("/getRecycleFiles")
    @ResponseBody
    public Pagination<File> getRecycleFiles(Pagination page) {
        int fowner = Integer.parseInt(request.getParameter("fowner"));
        return this.fileService.getRecycleFiles(page, fowner);
    }

    @GetMapping("/dropFile")
    @ResponseBody
    public ApiResult dropFile(@RequestParam("fid") int fid, @RequestParam("fpath") String fpath) {
        ApiResult result = this.hdfsService.delete(fpath);
        if (result.getCode() == ApiCodeConstant.RESULT_SUCC) {
            int flag = this.fileService.dropFile(fid);
            if (flag > 0) {
                return ApiResult.success();
            }
        }
        File file = this.fileService.getFileByFileId(fid);
        if (file != null) {
            this.fileService.dropFile(fid);
            return ApiResult.success();
        }
        return ApiResult.failure("operate Failure !");
    }

    @GetMapping("/recoveryFile")
    @ResponseBody
    public ApiResult recoveryFile(@RequestParam("fid") int fid) {
        return this.fileService.recoveryFile(fid);
    }

    @GetMapping("/recoveryFiles")
    @ResponseBody
    public ApiResult recoveryFiles(@RequestParam("fids") String fids) {
        return this.fileService.recoveryFiles(fids);
    }

    @GetMapping("/collectFile")
    @ResponseBody
    public ApiResult collectFile(@RequestParam("fid") int fid) {
        return this.fileService.collectFile(fid);
    }


    @GetMapping("/getCollectFiles")
    @ResponseBody
    public Pagination<File> getCollectFiles(Pagination page) {
        int fowner = Integer.parseInt(request.getParameter("fowner"));
        return this.fileService.getCollectFiles(page, fowner);
    }

    @GetMapping("/dislikeFile")
    @ResponseBody
    public ApiResult dislikeFile(@RequestParam("fid") int fid) {
        return this.fileService.dislikeFile(fid);
    }

    @RequestMapping("/getFileType")
    public ApiResult getFileType(@RequestParam("fid") int fid) {
        return ApiResult.success(this.fileService.getFileByFileId(fid).getFtype());
    }

    @PostMapping("/insertDir")
    @ResponseBody
    public ApiResult insertDir(File file) throws IOException {
        String path = file.getFpath() + file.getFname() + "/";
        ApiResult result = this.hdfsService.mkdirs(path);
        file.setFpath(path);
        if (result.getCode() == ApiCodeConstant.RESULT_SUCC) {
            int flag = this.fileService.insertDir(file);
            if (flag > 0) {
                return ApiResult.success();
            } else
                this.hdfsService.delete(file.getFpath());

        }
        return ApiResult.failure("operate Failure !");

    }

    @GetMapping("/dropDir")
    @ResponseBody
    public ApiResult dropDir(@RequestParam("fid") int fid, @RequestParam("fpathz") String fpathz) {

        ApiResult result = this.hdfsService.delete(fpathz);
        if (result.getCode() == ApiCodeConstant.RESULT_SUCC) {

            int flag = this.fileService.dropDir(fid);
            if (flag > 0) {
                return ApiResult.success();
            }
        }
        return ApiResult.failure("operate Failure !");
    }

    @GetMapping("/preView")
    @ResponseBody
    public ResponseEntity<byte[]> preView(@RequestParam("fid") int fid) throws IOException {
        File file = fileService.getFileById(fid);
        String fPath = file.getFpath();
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
        headers.setContentDispositionFormData("attachment", URLEncoder.encode(fPath, "UTF-8"));
        InputStream input = this.hdfsService.download(fPath);
        return new ResponseEntity<byte[]>(IOUtils.toByteArray(input), headers, HttpStatus.OK);

    }
}
